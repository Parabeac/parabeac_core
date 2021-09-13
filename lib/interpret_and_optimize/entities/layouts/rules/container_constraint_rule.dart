import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:uuid/uuid.dart';

class ContainerConstraintRule extends PostConditionRule {
  @override
  dynamic executeAction(PBContext context,
      PBIntermediateNode currentNode, PBIntermediateNode nextNode) {
    if (testRule(context, currentNode, nextNode)) {
      var container = InjectedContainer(null, currentNode.frame,
          name: currentNode.name,
          // constraints: currentNode.constraints
          );
    //FIXME container.addChild(currentNode);
      return container;
    }
    return currentNode;
  }

  @override
  bool testRule(PBContext context, PBIntermediateNode currentNode, PBIntermediateNode nextNode) =>
      (currentNode != null && currentNode is PBLayoutIntermediateNode);
}
