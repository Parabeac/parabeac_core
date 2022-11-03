import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_material.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/element_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:quick_log/quick_log.dart';
import 'package:recase/recase.dart';
import 'package:tuple/tuple.dart';
import 'dart:collection';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:directed_graph/directed_graph.dart';

part 'pb_intermediate_node_tree.g.dart';

enum TREE_TYPE {
  MISC,
  SCREEN,
  VIEW,
}

@JsonSerializable()
class PBIntermediateTree extends DirectedGraph<PBIntermediateNode> {
  Logger _logger;
  String _UUID;
  String get UUID => _UUID;

  @JsonKey(ignore: true)
  PBContext context;

  /// The [TREE_TYPE] of the [PBIntermediateTree].
  @JsonKey(ignore: true)
  TREE_TYPE tree_type = TREE_TYPE.SCREEN;

  /// This flag makes the data in the [PBIntermediateTree] unmodifiable. Therefore,
  /// if a change is made and [lockData] is `true`, the change is going to be ignored.
  ///
  /// This is a workaround to process where the data needs to be analyzed without any modification done to it.
  /// Furthermore, this is a workaround to the unability of creating a copy of the [PBIntermediateTree] to prevent
  /// the modifications to the object (https://github.com/dart-lang/sdk/issues/3367). As a result, the [lockData] flag
  /// has to be used to prevent those modification in phases where the data needs to be analyzed but unmodified.
  @JsonKey(ignore: true)
  bool lockData = false;

  @JsonKey(defaultValue: true)
  bool convert;

  PBGenerationViewData _generationViewData;
  @JsonKey(ignore: true)
  PBGenerationViewData get generationViewData => _generationViewData;
  set generationViewData(PBGenerationViewData viewData) {
    if (!lockData) {
      _generationViewData = viewData;
    }
  }

  @JsonKey(ignore: true)
  PBIntermediateNode _rootNode;
  @JsonKey(ignore: true)
  PBIntermediateNode get rootNode => _rootNode;
  set rootNode(PBIntermediateNode rootNode) {
    if (!lockData) {
      _rootNode = rootNode;
      _identifier ??= rootNode?.name?.snakeCase ?? name.snakeCase;

      if (rootNode is InheritedScaffold || rootNode is InheritedMaterial) {
        tree_type = TREE_TYPE.SCREEN;
      } else if (rootNode is PBSharedMasterNode) {
        tree_type = TREE_TYPE.VIEW;
      } else {
        tree_type = TREE_TYPE.MISC;
      }
    }
  }

  /// List of [PBIntermediteTree]s that `this` depends on.
  ///
  /// In other words, `this` can not be generated until its [dependentsOn]s are generated.
  Set<PBIntermediateTree> _dependentsOn;
  Iterator<PBIntermediateTree> get dependentsOn => _dependentsOn.iterator;

  /// The [name] of the original [DesignPage] that the [PBIntermediateTree] belongs to.
  String _name;
  String get name => _name.snakeCase;
  set name(String name) {
    if (!lockData) {
      _name = name;
    }
  }

  String get platformName => _name;

  final _childrenModObservers = <String, List<ChildrenModEventHandler>>{};

  ElementStorage _elementStorage;

  /// [identifier] represents the name of an actual tree or the [DesignScreen],
  /// while [name] originally represented the [name] of a [DesignPage].
  ///
  /// This primarly is used to group all [DesignScreen]s independent of their [UUID],
  /// platform or orientation. The [identifier] is just going to be set once, its going
  /// to be the [name] of the [rootNode].
  String _identifier;
  @JsonKey(name: 'name')
  String get identifier => _identifier?.camelCase?.snakeCase ?? 'no_name_found';

  @override
  @JsonKey(ignore: true)
  Comparator<Vertex<PBIntermediateNode>> get comparator => super.comparator;

  PBIntermediateTree({
    String name,
    this.context,
    Map<PBIntermediateNode, Set<PBIntermediateNode>> edges,
    Comparator<Vertex<PBIntermediateNode>> comparator,
  }) : super(edges ?? {}, comparator: comparator) {
    _name = name;
    _dependentsOn = {};
    _UUID = Uuid().v4();
    _logger = Logger(name ?? runtimeType.toString());
    _elementStorage = ElementStorage();
  }

  /// Finds a [PBIntermediateNode] that is a child of `parent` of `type` in the [PBIntermediateTree], containing `name`.
  ///
  /// Returns null if not found.
  PBIntermediateNode findChild(
      PBIntermediateNode parent, String name, Type type) {
    /// In case Parent is a Instances we look up for the hinttext
    /// inside the overridable properties and recursively call the method
    if (parent is PBSharedInstanceIntermediateNode) {
      for (var property in parent.sharedParamValues) {
        if (property.overrideName.contains(name)) {
          return findChild(property.value, name, type);
        }
      }
    }

    /// Check if the node is a match
    if (parent.name.contains(name) && parent.runtimeType == type) {
      return parent;
    }

    /// Check if node's children are a match
    for (var child in childrenOf(parent)) {
      var result = findChild(child, name, type);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  /// These are observers of [Vertex<PBIntermediateNode>] that will be added into [this]
  void addChildrenObeserver(String UUID, ChildrenModEventHandler oberver) {
    var mods = _childrenModObservers[UUID] ?? [];
    mods.add(oberver);
    _childrenModObservers[UUID] = mods;
  }

  List<PBIntermediateNode> childrenOf(PBIntermediateNode node) =>
      edges(node).cast<PBIntermediateNode>();

  @override
  void addEdges(Vertex<PBIntermediateNode> parent,
      [List<Vertex<PBIntermediateNode>> children]) {
    if (children == null) {}
    // var children = childrenVertices.map((e) => e).toList();

    /// Passing the responsability of acctually adding the [PBIntermediateNode] into
    /// the [tree] to the [parent.childStrategy]. The main reason for this is to enforce
    /// the strict policy that some [PBIntermediateNode] have when adding a node. Some
    /// nodes might just be allowed to have a single child, while others are can have more that
    /// one child.
    // ignore: omit_local_variable_types
    ChildrenMod<PBIntermediateNode> addChildren =
        (PBIntermediateNode parent, List<PBIntermediateNode> children) {
      children.forEach((child) {
        child.parent = parent;
        child.attributeName = parent.getAttributeNameOf(child);

        if (!_elementStorage.elementToTree.containsKey(child.UUID)) {
          _elementStorage.elementToTree[child.UUID] = _UUID;
        }
      });

      if (parent is ChildrenObserver && context != null) {
        (parent as ChildrenObserver).childrenModified(children, context);
      }
      return super.addEdges(parent, children);
    };
    (parent as PBIntermediateNode).childrenStrategy.addChild(
        parent, children.cast<PBIntermediateNode>(), addChildren, this);
  }

  @override
  void removeEdges(Vertex<PBIntermediateNode> parent,
      [List<Vertex<PBIntermediateNode>> children]) {
    if (parent is ChildrenObserver) {
      (parent as ChildrenObserver)
          .childrenModified(children?.cast<PBIntermediateNode>(), context);
    }
    super.removeEdges(parent, children);
  }

  @override

  /// Essentially [super.remove()], however, if [keepChildren] is `true`, its going
  /// to add the [edges(vertex)] into the [vertex.parent]; preventing the lost of the
  /// [edges(vertex)].
  void remove(Vertex<PBIntermediateNode> vertex, {bool keepChildren = false}) {
    if (keepChildren && vertex is PBIntermediateNode) {
      addEdges(vertex.parent, edges(vertex));
    }
    super.remove(vertex);
  }

  /// Adding [PBIntermediateTree] as a dependecy.
  ///
  /// The [dependent] or its [dependent.rootNode] can not be `null`
  void addDependent(PBIntermediateTree dependent) {
    if (dependent != null && !lockData) {
      _dependentsOn.add(dependent);
    }
  }

  void replaceChildrenOf(
      PBIntermediateNode parent, List<PBIntermediateNode> children) {
    removeEdges(parent);
    addEdges(parent, children.toList());
  }

  /// Wrapping [node] with [wrapper]
  ///
  /// When we need to put a specific parent node to the node on the tree
  void wrapNode(PBIntermediateNode wrapper, PBIntermediateNode node) {
    // Save children so we don't lose them
    var children = childrenOf(node);
    // Replace node by the wrapper
    replaceNode(node, wrapper);
    // Add them back
    addEdges(wrapper, [node]);
    addEdges(node, children);
  }

  /// Replacing [target] with [replacement]
  ///
  /// The entire subtree (starting with [target]) if [replacement] does not [acceptChildren],
  /// otherwise, those children would be appended to [replacement].
  bool replaceNode(PBIntermediateNode target, PBIntermediateNode replacement,
      {bool acceptChildren = false}) {
    if (target.parent == null) {
      throw Error();
    }

    // Create copy of children of `target` in order to not lose
    // reference of them when removing `target`
    var children = childrenOf(target);

    remove(target);

    if (acceptChildren) {
      addEdges(replacement, children);
    }

    addEdges(target.parent, [replacement]);
    return true;
  }

  /// Inserts [insertee] between [parent] and [child].
  ///
  /// As a side effect, [insertee] will be the new parent of [child].
  /// Additionally, [insertee] will be the new child of [parent].
  void injectBetween(
      {PBIntermediateNode parent,
      PBIntermediateNode child,
      PBIntermediateNode insertee}) {
    assert(parent != null && child != null && insertee != null);

    addEdges(insertee, [child]);
    removeEdges(parent, [child]);
    addEdges(parent, [insertee]);

    if (child.parent != insertee || insertee.parent != parent) {
      _logger.warning(
          'Injecting `insertee` may have had side effects on the graph.');
    }
  }

  /// Checks if the [PBIntermediateTree] is a [TREE_TYPE.SCREEN],
  /// meaning that the [rootNode] is of type [InheritedScaffold]
  bool isScreen() => tree_type == TREE_TYPE.SCREEN;

  bool isHomeScreen() => isScreen() && rootNode is InheritedScaffold
      ? (rootNode as InheritedScaffold).isHomeScreen
      : false;

  /// Finding the depth of the [node] in relation to the [rootNode].
  int depthOf(node) {
    return dist(rootNode, node);
  }

  /// Find the distance between [source] and [target], where the [source] is an
  /// ancestor of [target].
  ///
  /// IF [source] IS NOT AN ANCESTOR OF [target] OR [target] IS
  /// NOT PRESENT IN THE [PBIntermediateNode], THEN ITS GOING TO RETURN `-1`.
  /// This is because the nodes of the tree dont have an out going edge
  /// pointing towards its parents, all directed edges are going down the tree.
  int dist(
    PBIntermediateNode source,
    PBIntermediateNode target,
  ) =>
      shortestPath(source, target)?.length ?? -1;

  Map<String, dynamic> toJson() => _$PBIntermediateTreeToJson(this);

  static PBIntermediateTree fromJson(Map<String, dynamic> json) {
    if (!json['name'].contains('<custom>')) {
      json['name'] = PBInputFormatter.formatPageName(
        json['name'],
      );
      json['designNode']['name'] = PBInputFormatter.formatPageName(
        json['designNode']['name'],
      );
    }
    var tree = _$PBIntermediateTreeFromJson(json);
    var designNode =
        PBIntermediateNode.fromJson(json['designNode'], null, tree);
    tree.rootNode = designNode;
    return tree;
  }
}

/// This interface serves as a communication channel between the [PBIntermediateNTree] and [PBIntermediateNode].
///
/// Any [PBIntermediateNode] that wants to peform any additional logic based on its children modification
/// has to implement [ChildrenObserver]. The method [childrenModified(children)] is going to be called anytime
/// the [PBIntermediateNode]'s children are removed/added.
abstract class ChildrenObserver {
  /// Even notification of [children] have been modified.
  ///
  /// [context] could be `null` when when the [PBIntermediateTree] is being initialized. [ChildrenObserver]
  /// can still modify the [children] but it would be unable to add/remove children.
  void childrenModified(List<PBIntermediateNode> children, [PBContext context]);
}

enum CHILDREN_MOD { CREATED, REMOVED, MODIFIED }

typedef ChildrenModEventHandler = void Function(
    CHILDREN_MOD, List<PBIntermediateNode>);
typedef ChildrenMod<T> = void Function(T parent, List<T> children);

TREE_TYPE treeTypeFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'artboard':
      return TREE_TYPE.SCREEN;
    case 'shared_master':
      return TREE_TYPE.VIEW;
    default:
      return TREE_TYPE.MISC;
  }
}
