import 'package:parabeac_core/generation/generators/layouts/pb_stack_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_positioned.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/axis_comparison_rules.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:uuid/uuid.dart';

///Row contains nodes that are all `overlapping` to each other, without overlapping eachother

class PBIntermediateStackLayout extends PBLayoutIntermediateNode {
  static final List<LayoutRule> STACK_RULES = [OverlappingNodesLayoutRule()];

  @override
  PBContext currentContext;

  @override
  final String UUID;

  @override
  Map alignment = {};

  @override
  PrototypeNode prototypeNode;

  PBIntermediateStackLayout(String name, this.UUID, {this.currentContext})
      : super(STACK_RULES, [], currentContext, name) {
    generator = PBStackGenerator();
  }

  @override
  void addChild(PBIntermediateNode node) => addChildToLayout(node);

  /// Do we need to subtract some sort of offset? Maybe child.topLeftCorner.x - topLeftCorner.x?
  @override
  void alignChildren() {
    var alignedChildren = <PBIntermediateNode>[];
    for (var child in children) {
      if (child.topLeftCorner == topLeftCorner &&
          child.bottomRightCorner == bottomRightCorner) {
        //if they are the same size then there is no need for adjusting.
        alignedChildren.add(child);
        continue;
      }

      double top, bottom, left, right;

      top = child.topLeftCorner.y - topLeftCorner.y;
      bottom = bottomRightCorner.y - child.bottomRightCorner.y;

      left = child.topLeftCorner.x - topLeftCorner.x;
      right = bottomRightCorner.x - child.bottomRightCorner.x;

      alignedChildren.add(InjectedPositioned(Uuid().v4(),
          valueHolder: PositionedValueHolder(
            top: top,
            bottom: bottom,
            left: left,
            right: right,
          ),
          currentContext: currentContext,
          constraints: child.constraints)
        ..addChild(child));
    }
    replaceChildren(alignedChildren);
  }

  @override
  PBLayoutIntermediateNode generateLayout(List<PBIntermediateNode> children,
      PBContext currentContext, String name) {
    /// The width of this stack must be the full width of the Scaffold or Artboard. As discussed, at some point we can change this but for now, this makes the most sense.
    var stack = PBIntermediateStackLayout(
      name,
      Uuid().v4(),
      currentContext: currentContext,
    );
    stack.prototypeNode = prototypeNode;
    children.forEach((child) => stack.addChild(child));
    return stack;
  }
}
