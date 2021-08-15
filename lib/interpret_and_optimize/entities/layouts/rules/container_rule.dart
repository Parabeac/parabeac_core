import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/axis_comparison_rules.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

class ContainerPostRule extends PostConditionRule {
  OverlappingNodesLayoutRule overlappingNodesLayoutRule;

  ContainerPostRule() {
    overlappingNodesLayoutRule = OverlappingNodesLayoutRule();
  }

  /// Returns true if `currentNode` is a [PBIntermediateStackLayout] with two
  /// children: a [PBVisualIntermediateNode] and [PBLayoutIntermediateNode] that
  /// have overlapping coordinates.
  @override
  bool testRule(PBContext context, PBIntermediateNode currentNode,
      PBIntermediateNode nextNode) {
    var layout =
        currentNode is PBIntermediateStackLayout ? currentNode : nextNode;
    var tree = context.tree;
    if (layout == null || layout is! PBIntermediateStackLayout) {
      return false;
    }
    var children = tree.childrenOf(layout);
    if (children.length == 2) {
      if ((children[0] is PBVisualIntermediateNode &&
              children[1] is PBLayoutIntermediateNode) ||
          (children[1] is PBVisualIntermediateNode &&
              children[0] is PBLayoutIntermediateNode)) {
        var pblayout = children
                .firstWhere((element) => element is PBLayoutIntermediateNode),
            pbvisual = children
                .firstWhere((element) => element is PBVisualIntermediateNode);
        return overlappingNodesLayoutRule.testRule(context, pbvisual, pblayout) &&
            tree.childrenOf(pbvisual).isNotEmpty;
      }
    }
    return false;
  }

  /// Removes the [PBIntermediateStackLayout] and wraps the
  /// [PBLayoutIntermediateNode] child with the [PBVisualIntermediateNode]
  /// child.
  @override
  dynamic executeAction(PBContext context, PBIntermediateNode currentNode,
      PBIntermediateNode nextNode) {
    if (testRule(context, currentNode, nextNode)) {
      var layout =
          currentNode is PBIntermediateStackLayout ? currentNode : nextNode;
      var tree = context.tree;
      var layoutChildren = tree.childrenOf(layout);
      var pblayout = layoutChildren
              .firstWhere((element) => element is PBLayoutIntermediateNode),
          pbvisual = layoutChildren
              .firstWhere((element) => element is PBVisualIntermediateNode);
      tree.addEdges(AITVertex(pbvisual), [AITVertex(pblayout)]);
      //FIXME pbvisual.addChild(pblayout);
      layout = pbvisual;
      return layout;
    }
  }
}
