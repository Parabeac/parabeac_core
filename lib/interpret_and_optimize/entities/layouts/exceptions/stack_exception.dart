import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/layout_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/axis_comparison_rules.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';

class ColumnOverlappingException extends LayoutException
    with AxisComparisonRule {
  @override
  bool testException(
      PBIntermediateNode currentNode, PBIntermediateNode incomingNode) {
    return (areXCoordinatesOverlapping(
            currentNode.topLeftCorner,
            currentNode.bottomRightCorner,
            incomingNode.topLeftCorner,
            currentNode.bottomRightCorner) &&
        (currentNode is PBLayoutIntermediateNode &&
            currentNode is! TempGroupLayoutNode &&
            currentNode is! PBIntermediateStackLayout));
  }
}

class RowOverlappingException extends LayoutException with AxisComparisonRule {
  @override
  bool testException(
      PBIntermediateNode currentNode, PBIntermediateNode incomingNode) {
    return (areYCoordinatesOverlapping(
            currentNode.topLeftCorner,
            currentNode.bottomRightCorner,
            incomingNode.topLeftCorner,
            incomingNode.bottomRightCorner) &&
        (currentNode is PBLayoutIntermediateNode &&
            currentNode is! TempGroupLayoutNode &&
            currentNode is! PBIntermediateStackLayout));
  }
}
