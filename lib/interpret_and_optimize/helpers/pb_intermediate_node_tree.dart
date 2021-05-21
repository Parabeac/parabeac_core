import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:uuid/uuid.dart';

enum TREE_TYPE {
  MISC,
  SCREEN,
  VIEW,
}

class PBIntermediateTree {
  String _UUID;
  String get UUID => _UUID;

  TREE_TYPE tree_type = TREE_TYPE.SCREEN;
  PBGenerationViewData data;
  PBIntermediateNode _rootNode;
  set rootNode(PBIntermediateNode rootNode) {
    _rootNode = rootNode;
    identifier = rootNode?.name ?? name;
  }

  PBIntermediateNode get rootNode => _rootNode;

  /// List of [PBIntermediteTree]s that `this` depends on.
  ///
  /// In other words, `this` can not be generated until its [dependentsOn]s are generated.
  Set<PBIntermediateTree> _dependentsOn;
  Iterator<PBIntermediateTree> get dependentOn =>
      _dependentsOn.where((depedent) => depedent != null).iterator;

  String name;
  String identifier;

  List<PBIntermediateTree> dependentsOn;

  PBIntermediateTree(this.name) {
    _dependentsOn = {};
    _UUID = Uuid().v4();
  }

  /// Adding [PBIntermediateTree] as a dependecy.
  ///
  /// The [dependent] or its [dependent.rootNode] can not be `null`
  void addDependent(PBIntermediateTree dependent) {
    if (dependent != null && dependent.rootNode != null) {
      _dependentsOn.add(dependent);
    }
  }
}
