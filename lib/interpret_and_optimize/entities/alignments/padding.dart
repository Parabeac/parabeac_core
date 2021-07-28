import 'package:parabeac_core/generation/generators/visual-widgets/pb_padding_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';

class Padding extends PBVisualIntermediateNode {
  double left, right, top, bottom, screenWidth, screenHeight;

  Map padding;

  PBIntermediateConstraints childToParentConstraints;

  @override
  ChildrenStrategy childrenStrategy = OneChildStrategy('child');


  Padding(
    String UUID,
    this.childToParentConstraints, {
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    Point topLeftCorner,
    Point bottomRightCorner,
    PBContext currentContext,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, '', UUID: UUID) {
    generator = PBPaddingGen();
  }

  @override
  void addChild(node) {
    assert(child == null, 'Padding cannot accept multiple children.');
    child = node;

    // Calculate art board with
    screenWidth = child.currentContext == null
        ? (child.bottomRightCorner.x - child.topLeftCorner.x).abs()
        : (child.currentContext.screenBottomRightCorner.x -
                child.currentContext.screenTopLeftCorner.x)
            .abs();
    // Calculate art board height
    screenHeight = child.currentContext == null
        ? (child.bottomRightCorner.y - child.topLeftCorner.y).abs()
        : (child.currentContext.screenBottomRightCorner.y -
                child.currentContext.screenTopLeftCorner.y)
            .abs();

    /// Calculating the percentage of the padding in relation to the [screenHeight] and the [screenWidth].
    /// FIXME: creating a lifecyle between the [PBGenerator] and the [PBIntermediateNode] where it provides a callback that
    /// executes just before the generator generates the code for the [PBIntermediateNode].
    screenHeight = screenHeight == 0 ? 1 : screenHeight;
    screenWidth = screenWidth == 0 ? 1 : screenWidth;
    if (left != null && !childToParentConstraints.pinLeft) {
      left = (left / screenWidth);
      left = left < 0.01 ? 0.0 : left;
    }
    if (right != null && !childToParentConstraints.pinRight) {
      right = right / screenWidth;
      right = right < 0.01 ? 0.0 : right;
    }
    if (top != null && !childToParentConstraints.pinTop) {
      top = top / screenHeight;
      top = top < 0.01 ? 0.0 : top;
    }
    if (bottom != null && !childToParentConstraints.pinBottom) {
      bottom = bottom / screenHeight;
      bottom = bottom < 0.01 ? 0.0 : bottom;
    }
  }
}
