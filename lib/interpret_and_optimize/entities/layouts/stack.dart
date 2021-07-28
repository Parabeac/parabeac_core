import 'package:parabeac_core/generation/generators/layouts/pb_stack_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_positioned.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/axis_comparison_rules.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:uuid/uuid.dart';

///Row contains nodes that are all `overlapping` to each other, without overlapping eachother

class PBIntermediateStackLayout extends PBLayoutIntermediateNode {
  static final List<LayoutRule> STACK_RULES = [OverlappingNodesLayoutRule()];

  @override
  Map alignment = {};

  @override
  PrototypeNode prototypeNode;


  PBIntermediateStackLayout(PBContext currentContext,
      {String name, PBIntermediateConstraints constraints})
      : super(STACK_RULES, [], currentContext, name, constraints: constraints) {
    generator = PBStackGenerator();
    alignStrategy = PositionedAlignment();
  }

  @override
  void addChild(node) => addChildToLayout(node);

  @override
  void resize() {
    var depth = currentContext.tree?.depthOf(this);

    /// Since there are cases where [Stack] are being created, and
    /// childrend are being populated, and consequently [Stack.resize] is being
    /// called, then [depth] could be null. [depth] is null when the [PBIntermediateTree]
    /// has not finished creating and converting PBDL nodes into [PBIntermediateNode].
    if (depth != null && depth <= 1 && depth >= 0) {
      topLeftCorner = currentContext.canvasTLC;
      bottomRightCorner = currentContext.canvasBRC;
    } else {
      super.resize();
    }
  }

  @override
  PBLayoutIntermediateNode generateLayout(List<PBIntermediateNode> children,
      PBContext currentContext, String name) {
    /// The width of this stack must be the full width of the Scaffold or Artboard. As discussed, at some point we can change this but for now, this makes the most sense.
    var stack = PBIntermediateStackLayout(currentContext, name: name);
    stack.prototypeNode = prototypeNode;
    children.forEach((child) => stack.addChild(child));
    return stack;
  }
}
