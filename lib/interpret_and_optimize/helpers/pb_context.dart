import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class PBContext {
  final PBConfiguration configuration;

  /// These are the original screen mesurements comming from the design values.
  Point _screenTLC;
  Point get screenTopLeftCorner => _screenTLC;
  set screenTopLeftCorner(Point screenTopLeftCorner) {
    if (_screenTLC == null) {
      canvasTLC = screenTopLeftCorner;
    }
    _screenTLC = screenTopLeftCorner;
  }

  Point _screenBRC;
  Point get screenBottomRightCorner => _screenBRC;
  set screenBottomRightCorner(Point screenBottomRightCorner) {
    if (_screenBRC == null) {
      canvasBRC = screenBottomRightCorner;
    }
    _screenBRC = screenBottomRightCorner;
  }

  double get originalScreenWidth => Point.dist(_screenTLC, _screenBRC);
  double get originaScreenHeight => Point.dist(_screenTLC, _screenBRC, false);

  /// These values represent the current "focus area" size as it travels down the
  /// tree.
  ///
  /// The size of the canvas is changed by some widgets, for example, if there is an
  /// appbar declared in the Scaffold, then the canvas should decrese in size to accomodate for that.
  /// Some of the scenarios the focusAreaWould change:
  /// - When the appbar is used, it should shrink the canvas top point to make room for the appbar
  /// - When another stack is declared, its TLC becomes the new canvas TLC(same for BRC).
  Point canvasTLC;
  Point canvasBRC;

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

  /// Getting the correct ratio measurement in respect to the original [screenTopLeftCorner]
  /// or the [screenBottomRightCorner] sizes.
  ///
  /// [isHorizontal] (default value is `false`)
  /// represents if the ratio should be the Horizontal one or the Vertical one.
  double getRatioPercentage(double size, [bool isHorizontal = false]) {
    if (size == 0) {
      return size;
    }
    return isHorizontal ? size / originalScreenWidth : size / originaScreenHeight;
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
