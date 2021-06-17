import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class PBContext {
  final PBConfiguration configuration;
  Point screenTopLeftCorner, screenBottomRightCorner;
  PBIntermediateTree tree;
  PBProject project;
  SizingValueContext sizingContext = SizingValueContext.PointValue;
  PBSharedMasterNode masterNode;

  ///TODO: This is going to change to the [GenerationConfiguration].
  PBGenerationManager generationManager;

  PBGenerationViewData get managerData => tree?.data;

  PBContext(this.configuration, {this.tree});

  void addDependent(PBIntermediateTree dependent) {
    if (dependent != null) {
      tree.addDependent(dependent);
    }
  }
}

enum SizingValueContext {
  /// Should be hardcoded values
  PointValue,

  /// Should be using BoxConstraints to scale
  ScaleValue,

  /// Should conform to the Layout Builder code, usually used when calling views.
  LayoutBuilderValue,

  /// TODO: Remove
  AppBarChild,
}
