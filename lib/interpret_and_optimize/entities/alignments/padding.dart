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
  
  Padding(
    String UUID,
    Rectangle3D frame,
    this.childToParentConstraints, {
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
  }) : super(
          UUID,
          frame,
          '',
        ) {
    generator = PBPaddingGen();
    childrenStrategy = OneChildStrategy('child');
  }

  @override
  void handleChildren(PBContext context) {
    screenHeight = context.screenFrame.height;
    screenWidth = context.screenFrame.width;

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
    super.handleChildren(context);
  }

  // @override
  // void addChild(PBIntermediateNode node) {
  //   assert(child == null, 'Padding cannot accept multiple children.');
  //   child = node;

  //   // Calculate art board with
  //   screenWidth = child.currentContext == null
  //       ? (child.frame.bottomRight.x - child.frame.topLeft.x).abs()
  //       : (child.currentContext.screenFrame.bottomRight.x -
  //               child.currentContext.screenFrame.topLeft.x)
  //           .abs();
  //   // Calculate art board height
  //   screenHeight = child.currentContext == null
  //       ? (child.frame.bottomRight.y - child.frame.topLeft.y).abs()
  //       : (child.currentContext.screenFrame.bottomRight.y -
  //               child.currentContext.screenFrame.topLeft.y)
  //           .abs();
  // }

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) => null;
}
