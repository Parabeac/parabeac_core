import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/layout_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/axis_comparison_rules.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';

class ColumnOverlappingException extends LayoutException
    with AxisComparisonRule {
  @override
  bool testException(
      PBIntermediateNode currentNode, PBIntermediateNode incomingNode) {
    return (areXCoordinatesOverlapping(
            currentNode.frame.topLeft,
            currentNode.frame.bottomRight,
            incomingNode.frame.topLeft,
            currentNode.frame.bottomRight) &&
        (currentNode is PBLayoutIntermediateNode &&
            currentNode is! Group &&
            currentNode is! PBIntermediateStackLayout));
  }
}

class RowOverlappingException extends LayoutException with AxisComparisonRule {
  @override
  bool testException(
      PBIntermediateNode currentNode, PBIntermediateNode incomingNode) {
    return (areYCoordinatesOverlapping(
            currentNode.frame.topLeft,
            currentNode.frame.bottomRight,
            incomingNode.frame.topLeft,
            incomingNode.frame.bottomRight) &&
        (currentNode is PBLayoutIntermediateNode &&
            currentNode is! Group &&
            currentNode is! PBIntermediateStackLayout));
  }
}
