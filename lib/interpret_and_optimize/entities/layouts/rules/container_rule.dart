import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/axis_comparison_rules.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';

class ContainerPostRule extends PostConditionRule {
  OverlappingNodesLayoutRule overlappingNodesLayoutRule;

  ContainerPostRule() {
    overlappingNodesLayoutRule = OverlappingNodesLayoutRule();
  }

  /// Returns true if `currentNode` is a [PBIntermediateStackLayout] with two
  /// children: a [PBVisualIntermediateNode] and [PBLayoutIntermediateNode] that
  /// have overlapping coordinates.
  @override
  bool testRule(PBIntermediateNode currentNode, PBIntermediateNode nextNode) {
    var layout =
        currentNode is PBIntermediateStackLayout ? currentNode : nextNode;
    if (layout == null || layout is! PBIntermediateStackLayout) {
      return false;
    }
    var children = (layout as PBLayoutIntermediateNode).children;
    if (children.length == 2) {
      if ((children[0] is PBVisualIntermediateNode &&
              children[1] is PBLayoutIntermediateNode) ||
          (children[1] is PBVisualIntermediateNode &&
              children[0] is PBLayoutIntermediateNode)) {
        var pblayout = children
                .firstWhere((element) => element is PBLayoutIntermediateNode),
            pbvisual = children
                .firstWhere((element) => element is PBVisualIntermediateNode);
        return overlappingNodesLayoutRule.testRule(pbvisual, pblayout) &&
            (pbvisual as PBVisualIntermediateNode).children.isNotEmpty;
      }
    }
    return false;
  }

  /// Removes the [PBIntermediateStackLayout] and wraps the
  /// [PBLayoutIntermediateNode] child with the [PBVisualIntermediateNode]
  /// child.
  @override
  dynamic executeAction(
      PBIntermediateNode currentNode, PBIntermediateNode nextNode) {
    if (testRule(currentNode, nextNode)) {
      var layout =
          currentNode is PBIntermediateStackLayout ? currentNode : nextNode;
      var pblayout = (layout as PBLayoutIntermediateNode)
              .children
              .firstWhere((element) => element is PBLayoutIntermediateNode),
          pbvisual = (layout as PBLayoutIntermediateNode)
              .children
              .firstWhere((element) => element is PBVisualIntermediateNode);
   //FIXME pbvisual.addChild(pblayout);
      layout = pbvisual;
      return layout;
    }
  }
}
