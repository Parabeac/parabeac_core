import 'package:parabeac_core/generation/generators/layouts/pb_stack_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_positioned.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/axis_comparison_rules.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:uuid/uuid.dart';

import 'package:json_annotation/json_annotation.dart';

part 'stack.g.dart';

///Row contains nodes that are all `overlapping` to each other, without overlapping eachother
@JsonSerializable(nullable: true)
class PBIntermediateStackLayout extends PBLayoutIntermediateNode {
  @JsonKey(ignore: true)
  static final List<LayoutRule> STACK_RULES = [OverlappingNodesLayoutRule()];

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  @override
  final String UUID;

  Point topLeftCorner;

  Point bottomRightCorner;

  Map alignment = {};

  String widgetType = 'Stack';

  PBIntermediateStackLayout({this.UUID, this.currentContext})
      : super(STACK_RULES, [], currentContext) {
    generator = PBStackGenerator();
  }

  @override
  void addChild(PBIntermediateNode node) => addChildToLayout(node);

  /// Do we need to subtract some sort of offset? Maybe child.topLeftCorner.x - topLeftCorner.x?
  @override
  void alignChildren() {
    var alignedChildren = <PBIntermediateNode>[];
    for (var child in children) {
      var positionedHolder = PositioningHolder();

      if (child.topLeftCorner == topLeftCorner &&
          child.bottomRightCorner == bottomRightCorner) {
        //if they are the same size then there is no need for adjusting.
        alignedChildren.add(child);
        continue;
      }
      positionedHolder.h_type =
          (child.topLeftCorner.x - topLeftCorner.x).abs() <=
                  (bottomRightCorner.x - child.bottomRightCorner.x).abs()
              ? HorizontalAlignType.left
              : HorizontalAlignType.right;
      positionedHolder.h_value =
          positionedHolder.h_type == HorizontalAlignType.left
              ? child.topLeftCorner.x - topLeftCorner.x
              : bottomRightCorner.x - child.bottomRightCorner.x;
      positionedHolder.v_type =
          (child.topLeftCorner.y - topLeftCorner.y).abs() <=
                  (bottomRightCorner.y - child.bottomRightCorner.y).abs()
              ? VerticalAlignType.top
              : VerticalAlignType.bottom;
      positionedHolder.v_value =
          positionedHolder.v_type == VerticalAlignType.top
              ? child.topLeftCorner.y - topLeftCorner.y
              : bottomRightCorner.y - child.bottomRightCorner.y;

      alignedChildren.add(InjectedPositioned(Uuid().v4(),
          positionedHolder: positionedHolder, currentContext: currentContext)
        ..addChild(child));
    }
    replaceChildren(alignedChildren);
  }

  @override
  PBLayoutIntermediateNode generateLayout(
      List<PBIntermediateNode> children, PBContext currentContext) {
    /// The width of this stack must be the full width of the Scaffold or Artboard. As discussed, at some point we can change this but for now, this makes the most sense.
    var stack =
        PBIntermediateStackLayout(Uuid().v4(), currentContext: currentContext);
    stack.prototypeNode = prototypeNode;
    children.forEach((child) => stack.addChild(child));
    return stack;
  }

  factory PBIntermediateStackLayout.fromJson(Map<String, Object> json) =>
      _$PBIntermediateStackLayoutFromJson(json);
  Map<String, Object> toJson() => _$PBIntermediateStackLayoutToJson(this);
}
