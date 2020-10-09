import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:uuid/uuid.dart';

class ContainerConstraintRule extends PostConditionRule {
  @override
  dynamic executeAction(
      PBIntermediateNode currentNode, PBIntermediateNode nextNode) {
    if (testRule(currentNode, nextNode)) {
      var container = InjectedContainer(currentNode.bottomRightCorner,
          currentNode.topLeftCorner, Uuid().v4(), '',
          currentContext: currentNode.currentContext);
      container.addChild(currentNode);
      return container;
    }
    return currentNode;
  }

  @override
  bool testRule(PBIntermediateNode currentNode, PBIntermediateNode nextNode) =>
      (currentNode != null && currentNode is PBLayoutIntermediateNode);
}
