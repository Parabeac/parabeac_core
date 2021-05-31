import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_dfs_iterator.dart';
import 'package:uuid/uuid.dart';

enum TREE_TYPE {
  MISC,
  SCREEN,
  VIEW,
}

class PBIntermediateTree extends Iterable<PBIntermediateNode> {
  String _UUID;
  String get UUID => _UUID;

  TREE_TYPE tree_type = TREE_TYPE.SCREEN;

  /// This flag makes the data in the [PBIntermediateTree] unmodifiable. Therefore,
  /// if a change is made and [lockData] is `true`, the change is going to be ignored.
  ///
  /// This is a workaround to process where the data needs to be analyzed without any modification done to it.
  /// Furthermore, this is a workaround to the unability of creating a copy of the [PBIntermediateTree] to prevent
  /// the modifications to the object (https://github.com/dart-lang/sdk/issues/3367). As a result, the [lockData] flag
  /// has to be used to prevent those modification in phases where the data needs to be analyzed but unmodified.
  bool lockData = false;

  PBGenerationViewData _data;
  PBGenerationViewData get data => _data;
  set data(PBGenerationViewData viewData) {
    if (!lockData) {
      _data = viewData;
    }
  }

  PBIntermediateNode _rootNode;
  PBIntermediateNode get rootNode => _rootNode;
  set rootNode(PBIntermediateNode rootNode) {
    if (!lockData) {
      _rootNode = rootNode;
      identifier = rootNode?.name ?? name;
    }
  }

  /// List of [PBIntermediteTree]s that `this` depends on.
  ///
  /// In other words, `this` can not be generated until its [dependentsOn]s are generated.
  Set<PBIntermediateTree> _dependentsOn;
  Iterator<PBIntermediateTree> get dependentsOn => _dependentsOn.iterator;

  String name;
  String identifier;

  PBIntermediateTree(this.name) {
    _dependentsOn = {};
    _UUID = Uuid().v4();
  }

  /// Adding [PBIntermediateTree] as a dependecy.
  ///
  /// The [dependent] or its [dependent.rootNode] can not be `null`
  void addDependent(PBIntermediateTree dependent) {
    if (dependent != null && !lockData) {
      _dependentsOn.add(dependent);
    }
  }

  @override
  Iterator<PBIntermediateNode> get iterator => IntermediateDFSIterator(this);
}

/// By extending the class, any node could be used in any iterator to traverse its
/// internals.
///
/// In the example of the [PBIntermediateNode], you can traverse the [PBIntermediateNode]s
/// children by using the [IntermediateDFSIterator]. Furthermore, this allows the
/// [PBIntermediateTree] to traverse through its nodes, leveraging the dart methods.
abstract class TraversableNode<E> {
  List<E> children;
}
