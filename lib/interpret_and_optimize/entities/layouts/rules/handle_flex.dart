import 'package:parabeac_core/interpret_and_optimize/entities/alignments/flexible.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/spacer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/row.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';

/// Calculates the flex of a child relative to its parent
int _calculateFlex(num childLength, num parentLength) =>
    (childLength / parentLength * 100).ceil();

/// Calculates the vertical distance (height) of two points
/// by subtracting `point2 - point1`
num _calculateHeight(Point point1, Point point2) => (point2.y - point1.y);

/// Calculates the horizontal distance (width) of two points
/// by subtracting `point2 - point1`
num _calculateWidth(Point point1, Point point2) => (point2.x - point1.x);

/// Wraps the `children` of a [Row] or [Column] in [Flexibles]
/// according to the size of the children and the size of the row or column.
List<PBIntermediateNode> handleFlex(bool isVertical, Point topLeft,
    Point bottomRight, List<PBIntermediateNode> children) {
  var parentLength = isVertical
      ? _calculateHeight(topLeft, bottomRight)
      : _calculateWidth(topLeft, bottomRight);

  // This list will store the final wrapped children
  var resultingChildren = <PBIntermediateNode>[];

  for (var i = 0; i < children.length; i++) {
    var child = children[i];

    // Handle spacer of middle child
    if (i > 0) {
      var prevChild = children[i - 1];

      var spacerLength = isVertical
          ? _calculateHeight(prevChild.frame.bottomRight, child.frame.topLeft)
          : _calculateWidth(prevChild.frame.bottomRight, child.frame.topLeft);

      if (spacerLength > 0) {
        var flex = _calculateFlex(spacerLength, parentLength);
        resultingChildren.add(Spacer(
          null,
          Rectangle.fromPoints(
              isVertical
                  ? Point(
                      prevChild.frame.topLeft.x, prevChild.frame.bottomRight.y)
                  : Point(
                      prevChild.frame.bottomRight.x, prevChild.frame.topLeft.y),
              isVertical
                  ? Point(child.frame.bottomRight.x, child.frame.topLeft.y)
                  : Point(
                      child.frame.topLeft.x, child.frame.bottomRight.y)), //brc

          flex: flex,
        ));
      }
    }

    if (child is! PBIntermediateRowLayout &&
        child is! PBIntermediateColumnLayout) {
      // Wrap text in container
      if (child is! InheritedText) {
        resultingChildren.add(_putChildInFlex(isVertical, child, parentLength));
      }
    } else {
      resultingChildren.add(child);
    }
  }
  return resultingChildren;
}

/// Wraps the [child] inside a `Flexible` and calculates the `flex`
/// based on [parentLength]
PBIntermediateNode _putChildInFlex(
    bool isVertical, PBIntermediateNode child, double parentLength) {
  //Calculate child flex
  var widgetLength = isVertical
      ? _calculateHeight(child.frame.topLeft, child.frame.bottomRight)
      : _calculateWidth(child.frame.topLeft, child.frame.bottomRight);
  var flex = _calculateFlex(widgetLength.abs(), parentLength.abs());

  return Flexible(null, child.frame, child: child, flex: flex);
}
