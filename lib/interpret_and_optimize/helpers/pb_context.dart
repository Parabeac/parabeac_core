import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class PBContext {
  final PBConfiguration configuration;
  Point screenTopLeftCorner, screenBottomRightCorner;
  PBIntermediateTree tree;
  PBProject project;

  PBGenerationViewData get managerData => tree?.data;

  PBContext(this.configuration, {this.tree});

  void addDependent(PBIntermediateTree dependet) {
    tree.dependentsOn.add(dependet);
  }
}
