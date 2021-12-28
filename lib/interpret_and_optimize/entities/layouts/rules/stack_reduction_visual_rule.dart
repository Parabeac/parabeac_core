import 'package:parabeac_core/interpret_and_optimize/entities/container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/axis_comparison_rules.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

class StackReductionVisualRule extends PostConditionRule {
  OverlappingNodesLayoutRule _overlappingNodesLayoutRule;
  StackReductionVisualRule() {
    _overlappingNodesLayoutRule = OverlappingNodesLayoutRule();
  }

  /// Removes the [PBIntermediateStackLayout] and wraps the [PBVisualIntermediateNode]
  /// that has a child with the node that does not have a child.
  @override
  dynamic executeAction(PBContext context, PBIntermediateNode currentNode,
      PBIntermediateNode nextNode) {
    var currentTree = context.tree;
    if (testRule(context, currentNode, nextNode)) {
      var layout =
          currentNode is PBIntermediateStackLayout ? currentNode : nextNode;
      var children = currentTree.childrenOf(layout);
      var wrapper = children.firstWhere((element) =>
          element is PBVisualIntermediateNode &&
          currentTree.childrenOf(element).isEmpty);
      var child = children.firstWhere((element) =>
          element is PBVisualIntermediateNode &&
          currentTree.childrenOf(element).isEmpty);

      currentTree.addEdges(wrapper, [child]);
      if ((layout as PBIntermediateStackLayout).prototypeNode != null) {
        if (wrapper is PBInheritedIntermediate) {
          (wrapper as PBInheritedIntermediate).prototypeNode =
              (layout as PBIntermediateStackLayout).prototypeNode;
        } else if (wrapper is InjectedContainer) {
          wrapper.prototypeNode =
              (layout as PBIntermediateStackLayout).prototypeNode;
        }
      }
      layout = wrapper;
      return layout;
    }
  }

  /// Returns `true` if `currentNode` is a [PBIntermediateStackLayout] with
  /// two [PBVisualIntermediateNode]s, where one visual node should wrap the
  /// other.
  @override
  bool testRule(PBContext context, PBIntermediateNode currentNode,
      PBIntermediateNode nextNode) {
    var currTree = context.tree;
    var layout =
        currentNode is PBIntermediateStackLayout ? currentNode : nextNode;
    if (layout == null || layout is! PBIntermediateStackLayout) {
      return false;
    }

    var children = currTree.childrenOf(layout);
    if (children.length == 2 &&
        children[0] is PBVisualIntermediateNode &&
        children[1] is PBVisualIntermediateNode) {
      return _overlappingNodesLayoutRule.testRule(
              context, children[0], children[1]) &&
          ((_isEmptyContainer(currTree, children[0]) &&
                  currTree.childrenOf(children[1]).isNotEmpty) ||
              (_isEmptyContainer(currTree, children[0]) &&
                  currTree.childrenOf(children[0]).isNotEmpty));
    }
    return false;
  }

  /// Returns true if `node` is a Container with a null child
  bool _isEmptyContainer(
          PBIntermediateTree tree, PBVisualIntermediateNode node) =>
      tree.childrenOf(node).isEmpty && (node is PBContainer);
}
