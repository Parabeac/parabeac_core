import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'dart:math';

///provides comparison function for UI elements.
mixin AxisComparisonRule {
  ///Returns if the points [topLeftCorner0] and [bottomRightCorner0]
  ///are within the `horizontal range` of the second set of points [topLeftCorner1] and [bottomRightCorner]..
  bool areXCoordinatesOverlapping(
          Point topLeftCorner0,
          Point bottomRightCorner0,
          Point topLeftCorner1,
          Point bottomRightCorner1) =>
      topLeftCorner1.x >= topLeftCorner0.x &&
          topLeftCorner1.x < bottomRightCorner0.x ||
      bottomRightCorner1.x <= bottomRightCorner0.x &&
          bottomRightCorner1.x > topLeftCorner0.x;

  ///Returns if the points [topLeftCorner0] and [bottomRightCorner0]
  ///are within the `vertical range` of the second set of points [topLeftCorner1] and [bottomRightCorner].
  bool areYCoordinatesOverlapping(
          Point topLeftCorner0,
          Point bottomRightCorner0,
          Point topLeftCorner1,
          Point bottomRightCorner1) =>
      topLeftCorner1.y >= topLeftCorner0.y &&
          topLeftCorner1.y < bottomRightCorner0.y ||
      bottomRightCorner1.y <= bottomRightCorner0.y &&
          bottomRightCorner1.y > topLeftCorner0.y;
}

///Returns if the points [topLeftCorner0] and [bottomRightCorner0]
///are within the `horizontal range` and not in the `vertical range`
/// of the second set of points [topLeftCorner1] and [bottomRightCorner].
class HorizontalNodesLayoutRule extends LayoutRule with AxisComparisonRule {
  @override
  bool testRule(PBIntermediateNode currentNode, PBIntermediateNode nextNode) =>
      (!(areXCoordinatesOverlapping(
          currentNode .frame.topLeft,
          currentNode .frame.bottomRight,
          nextNode .frame.topLeft,
          nextNode .frame.bottomRight))) &&
      areYCoordinatesOverlapping(
          currentNode .frame.topLeft,
          currentNode .frame.bottomRight,
          nextNode .frame.topLeft,
          nextNode .frame.bottomRight);
}

///Returns if the points [topLeftCorner0] and [bottomRightCorner0]
///are within the `vertical range` and not in the `horicontal range`
/// of the second set of points [topLeftCorner1] and [bottomRightCorner].
class VerticalNodesLayoutRule extends LayoutRule with AxisComparisonRule {
  @override
  bool testRule(PBIntermediateNode currentNode, PBIntermediateNode nextNode) =>
      (!(areYCoordinatesOverlapping(
          currentNode .frame.topLeft,
          currentNode .frame.bottomRight,
          nextNode .frame.topLeft,
          nextNode .frame.bottomRight))) &&
      areXCoordinatesOverlapping(
          currentNode .frame.topLeft,
          currentNode .frame.bottomRight,
          nextNode .frame.topLeft,
          nextNode .frame.bottomRight);
}

class OverlappingNodesLayoutRule extends LayoutRule with AxisComparisonRule {
  @override
  bool testRule(PBIntermediateNode currentNode, PBIntermediateNode nextNode) =>
      currentNode.frame.containsPoint(nextNode.frame.topLeft) ||
      currentNode.frame.containsPoint(nextNode.frame.bottomRight);
  // (areXCoordinatesOverlapping(
  //     currentNode .frame.topLeft,
  //     currentNode .frame.bottomRight,
  //     nextNode .frame.topLeft,
  //     nextNode .frame.bottomRight)) &&
  // areYCoordinatesOverlapping(
  //     currentNode .frame.topLeft,
  //     currentNode .frame.bottomRight,
  //     nextNode .frame.topLeft,
  //     nextNode .frame.bottomRight);
}
