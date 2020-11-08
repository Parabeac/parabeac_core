import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/axis_comparison_rules.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';

class StackReductionVisualRule extends PostConditionRule {
  OverlappingNodesLayoutRule _overlappingNodesLayoutRule;
  StackReductionVisualRule() {
    _overlappingNodesLayoutRule = OverlappingNodesLayoutRule();
  }

  /// Removes the [PBIntermediateStackLayout] and wraps the [PBVisualIntermediateNode]
  /// that has a child with the node that does not have a child.
  @override
  dynamic executeAction(
      PBIntermediateNode currentNode, PBIntermediateNode nextNode) {
    if (testRule(currentNode, nextNode)) {
      var layout =
          currentNode is PBIntermediateStackLayout ? currentNode : nextNode;
      var wrapper = (layout as PBIntermediateStackLayout).children.firstWhere(
          (element) =>
              element is PBVisualIntermediateNode && element.child == null);
      var child = (layout as PBIntermediateStackLayout).children.firstWhere(
          (element) =>
              element is PBVisualIntermediateNode && element.child != null);

      wrapper.addChild(child);
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
  bool testRule(PBIntermediateNode currentNode, PBIntermediateNode nextNode) {
    var layout =
        currentNode is PBIntermediateStackLayout ? currentNode : nextNode;
    if (layout == null || layout is! PBIntermediateStackLayout) {
      return false;
    }

    var children = (layout as PBIntermediateStackLayout).children;
    if (children.length == 2 &&
        children[0] is PBVisualIntermediateNode &&
        children[1] is PBVisualIntermediateNode) {
      return _overlappingNodesLayoutRule.testRule(children[0], children[1]) &&
          ((_isEmptyContainer(children[0]) && children[1].child != null) ||
              (_isEmptyContainer(children[0]) && children[0].child != null));
    }
    return false;
  }

  /// Returns true if `node` is a Container with a null child
  bool _isEmptyContainer(PBVisualIntermediateNode node) =>
      node.child == null &&
      (node is InheritedContainer || node is InjectedContainer);
}
