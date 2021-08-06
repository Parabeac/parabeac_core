import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'dart:math';

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

  double get originalScreenWidth => _screenBRC.x - _screenTLC.x;
  double get originaScreenHeight => _screenBRC.y - _screenTLC.y;

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

  /// The [constextConstrains] represents the costraints that would be inherited by a section of the tree.
  ///
  /// For example, when there is a [InjectedPositioned] that contains [contextConstraints.fixedWidth], then
  /// all of the [InjectedPositioned.child] subtree should inherit that information.
  PBIntermediateConstraints contextConstraints;

  PBIntermediateTree tree;
  PBProject project;
  SizingValueContext sizingContext = SizingValueContext.PointValue;
  PBSharedMasterNode masterNode;

  ///TODO: This is going to change to the [GenerationConfiguration].
  PBGenerationManager generationManager;

  PBGenerationViewData get managerData => tree?.data;

  PBContext(this.configuration,
      {this.tree,
      this.contextConstraints,
      this.masterNode,
      this.project,
      this.canvasBRC,
      this.canvasTLC,
      this.generationManager}) {
    contextConstraints ??= PBIntermediateConstraints();
  }

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
  double getRatioPercentage(double size, {bool isHorizontal = false}) {
    if (size == 0) {
      return size;
    }
    return isHorizontal
        ? size / originalScreenWidth
        : size / originaScreenHeight;
  }

  PBContext clone() {
    var context = PBContext(configuration,
        tree: tree,
        contextConstraints: contextConstraints.clone(),
        masterNode: masterNode,
        project: project,
        canvasBRC: canvasBRC,
        canvasTLC: canvasTLC,
        generationManager: generationManager);
    context.screenTopLeftCorner = _screenTLC;
    context.screenBottomRightCorner = _screenBRC;
    return context;
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
