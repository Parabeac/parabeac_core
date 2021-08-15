import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/element_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_dfs_iterator.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_layer_iterator.dart';
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

  PBContext context;

  /// The [TREE_TYPE] of the [PBIntermediateTree].
  @JsonKey(ignore: true)
  TREE_TYPE tree_type = TREE_TYPE.SCREEN;

  @override
  @JsonKey(ignore: true)
  String type = 'tree';

  /// This flag makes the data in the [PBIntermediateTree] unmodifiable. Therefore,
  /// if a change is made and [lockData] is `true`, the change is going to be ignored.
  ///
  /// This is a workaround to process where the data needs to be analyzed without any modification done to it.
  /// Furthermore, this is a workaround to the unability of creating a copy of the [PBIntermediateTree] to prevent
  /// the modifications to the object (https://github.com/dart-lang/sdk/issues/3367). As a result, the [lockData] flag
  /// has to be used to prevent those modification in phases where the data needs to be analyzed but unmodified.
  @JsonKey(ignore: true)
  bool lockData = false;

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

      if (rootNode is InheritedScaffold) {
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

  // JsonKey()
  Map<PBIntermediateNode, List<PBIntermediateNode>> get children => data;

  ElementStorage _elementStorage;

  /// [identifier] represents the name of an actual tree or the [DesignScreen],
  /// while [name] originally represented the [name] of a [DesignPage].
  ///
  /// This primarly is used to group all [DesignScreen]s independent of their [UUID],
  /// platform or orientation. The [identifier] is just going to be set once, its going
  /// to be the [name] of the [rootNode].
  String _identifier;
  @JsonKey(name: 'name')
  String get identifier => _identifier?.snakeCase ?? 'no_name_found';

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

  @override
  void addEdges(Vertex<PBIntermediateNode> parentVertex,
      List<Vertex<PBIntermediateNode>> childrenVertices) {
    var parent = parentVertex.data;

    childrenVertices.forEach((childVertex) {
      var child = childVertex.data;
      child.parent = parent;
      child.attributeName = parent.getAttributeNameOf(child);

      if (!_elementStorage.elementToTree.containsKey(child.UUID)) {
        _elementStorage.elementToTree[child.UUID] = _UUID;
      }
    });

    super.addEdges(parentVertex as AITVertex,
        childrenVertices.cast<AITVertex>());
  }

  /// Adding [PBIntermediateTree] as a dependecy.
  ///
  /// The [dependent] or its [dependent.rootNode] can not be `null`
  void addDependent(PBIntermediateTree dependent) {
    if (dependent != null && !lockData) {
      _dependentsOn.add(dependent);
    }
  }

  /// Removing the [node] from the [PBIntermediateTree]
  ///
  /// The entire subtree (starting with [node]) would be eliminated if specified to [eliminateSubTree],
  /// otherwise, its just going to replace [node] with its [node.children]
  // bool removeNode(PBIntermediateNode node, {bool eliminateSubTree = false}) {
  //   if (node.parent == null) {
  //     ///TODO: log message
  //     return false;
  //   }
  //   var parent = node.parent;
  //   var removeChild = () =>
  //       parent.children.removeWhere((element) => element.UUID == node.UUID);

  //   if (eliminateSubTree) {
  //     removeChild();
  //   } else {
  //     /// appending the [PBIntermediateNode]s of the removed [node]
  //     var grandChilds = parent.children
  //         .where((element) => element.UUID == node.UUID)
  //         .map((e) => e.children)

  //         ///FIXME: Right now the iterator is returning null insize of a list when iterating the tree.
  //         .where((element) => element != null)
  //         .expand((element) => element)
  //         .toList();
  //     removeChild();
  //     grandChilds.forEach((element) => parent.addChild(element));
  //   }
  //   return true;
  // }

  /// Replacing [target] with [replacement]
  ///
  /// The entire subtree (starting with [target]) if [replacement] does not [acceptChildren],
  /// otherwise, those children would be appended to [replacement].
  // bool replaceNode(PBIntermediateNode target, PBIntermediateNode replacement,
  //     {bool acceptChildren = false}) {
  //   if (target.parent == null) {
  //     ///TODO: throw correct error/log
  //     throw Error();
  //   }

  //   var parent = target.parent;
  //   if (acceptChildren) {
  //     replacement.children.addAll(target.children.map((e) {
  //       e.parent = replacement;
  //       return e;
  //     }));
  //   }
  //   removeNode(target, eliminateSubTree: true);
  //   replacement.attributeName = target.attributeName;

  //   /// This conditional is for scenarios where both the [target] and the [replacement] are
  //   /// under the same [parent]
  //   if (!parent.children.contains(replacement)) {
  //     parent.children.add(replacement);
  //     replacement.parent = parent;
  //   }

  //   return true;
  // }

  /// Checks if the [PBIntermediateTree] is a [TREE_TYPE.SCREEN],
  /// meaning that the [rootNode] is of type [InheritedScaffold]
  bool isScreen() => tree_type == TREE_TYPE.SCREEN;

  bool isHomeScreen() =>
      isScreen() && (rootNode as InheritedScaffold).isHomeScreen;

  /// Finding the depth of the [node] in relation to the [rootNode].
  // int depthOf(node) {
  //   return dist(rootNode, node);
  // }

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
      shortestPath(Vertex(source), Vertex(target))?.length ?? -1;

  // @override
  // Iterator<PBIntermediateNode> get iterator => IntermediateDFSIterator(this);

  // Iterator get layerIterator => IntermediateLayerIterator(this);

  Map<String, dynamic> toJson() => _$PBIntermediateTreeToJson(this);

  static PBIntermediateTree fromJson(Map<String, dynamic> json) {
    var tree = _$PBIntermediateTreeFromJson(json);
    var designNode =
        PBIntermediateNode.fromJson(json['designNode'], null, tree);
    tree.addEdges(Vertex(designNode), []);
    tree._rootNode = designNode;

    List<Map<String, dynamic>> childrenPointer = json['designNode']['children'];

    /// Deserialize the rootNode
    /// Then make sure rootNode deserializes the rest of the tree.
    // ..addEdges(child, parentList)
    // ..tree_type = treeTypeFromJson(json['designNode']);
  }

  // @override
  // PBIntermediateTree createIntermediateNode(Map<String, dynamic> json) =>
  //     PBIntermediateTree.fromJson(json);
}

/// By extending the class, any node could be used in any iterator to traverse its
/// internals.
///
/// In the example of the [PBIntermediateNode], you can traverse the [PBIntermediateNode]s
/// children by using the [IntermediateDFSIterator]. Furthermore, this allows the
/// [PBIntermediateTree] to traverse through its nodes, leveraging the dart methods.
abstract class TraversableNode<E> {
  String attributeName;
  E parent;
  List<E> children;
}

class AITVertex<T extends PBIntermediateNode> extends Vertex<T> {
  AITVertex(T data) : super(data);

  @override
  int get id => data.UUID.hashCode;

  @override
  int get hashCode => data.UUID.hashCode;

  @override
  bool operator ==(Object other) => other is AITVertex<T> && other.id == id;
}

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
