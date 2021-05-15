import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

enum TREE_TYPE {
  MISC,
  SCREEN,
  VIEW,
}

class PBIntermediateTree {
  PBGenerationViewData data;
  PBIntermediateNode _rootNode;
  set rootNode(PBIntermediateNode rootNode) {
    _rootNode = rootNode;
    identifier = rootNode?.name ?? name;
  }

  PBIntermediateNode get rootNode => _rootNode;

  String name;
  String identifier;
  PBIntermediateTree(this.name);
  TREE_TYPE tree_type = TREE_TYPE.SCREEN;
}
