import 'package:parabeac_core/input/sketch/entities/style/shared_style.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

class PBProject {
  String projectName;
  String projectAbsPath;
  List<PBIntermediateTree> forest = [];
  List<SharedStyle> sharedStyles = [];

  PBProject(this.projectName, this.sharedStyles);
}
