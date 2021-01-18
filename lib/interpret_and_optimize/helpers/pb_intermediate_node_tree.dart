import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

enum TREE_TYPE {
  MISC,
  SCREEN,
  VIEW,
}

class PBIntermediateTree {
  PBGenerationViewData data;
  PBIntermediateNode rootNode;
  String name;
  PBIntermediateTree(this.name);
  TREE_TYPE tree_type = TREE_TYPE.SCREEN;
}
