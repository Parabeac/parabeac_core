import 'package:parabeac_core/generation/generators/visual-widgets/pb_padding_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'padding.g.dart';

@JsonSerializable(nullable: false)
class Padding extends PBVisualIntermediateNode {
  var child;
  double left, right, top, bottom, screenWidth, screenHeight;

  final String UUID;
  Map padding;

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  String widgetType = 'PADDING';

  @JsonKey(ignore: true)
  Point topLeftCorner;
  @JsonKey(ignore: true)
  Point bottomRightCorner;

  Padding(this.UUID,
      {this.left,
      this.right,
      this.top,
      this.bottom,
      this.topLeftCorner,
      this.bottomRightCorner,
      this.currentContext})
      : super(topLeftCorner, bottomRightCorner, currentContext, UUID: UUID) {
    generator = PBPaddingGen(currentContext.generationManager);
  }

  @override
  void addChild(PBIntermediateNode node) {
    assert(child == null, 'Padding cannot accept multiple children.');
    child = node;

    // Calculate art board with
    screenWidth = child.currentContext == null
        ? (child.bottomRightCorner.x - child.topLeftCorner.x).abs()
        : (child.currentContext.screenBottomRightCorner.x -
                child.currentContext.screenTopLeftCorner.x)
            .abs();
    // Calculate art board height
    screenHeight = child.currentContext == null
        ? (child.bottomRightCorner.y - child.topLeftCorner.y).abs()
        : (child.currentContext.screenBottomRightCorner.y -
                child.currentContext.screenTopLeftCorner.y)
            .abs();

    /// Calculating the percentage of the padding in relation to the [screenHeight] and the [screenWidth].
    /// FIXME: creating a lifecyle between the [PBGenerator] and the [PBIntermediateNode] where it provides a callback that
    /// executes just before the generator generates the code for the [PBIntermediateNode].
    screenHeight = screenHeight == 0 ? 1 : screenHeight;
    screenWidth = screenWidth == 0 ? 1 : screenWidth;
    if (left != null) {
      left = (left / screenWidth);
      left = left < 0.01 ? null : left;
    }
    if (right != null) {
      right = right / screenWidth;
      right = right < 0.01 ? null : right;
    }
    if (top != null) {
      top = top / screenHeight;
      top = top < 0.01 ? null : top;
    }
    if (bottom != null) {
      bottom = bottom / screenHeight;
      bottom = bottom < 0.01 ? null : bottom;
    }
  }

  factory Padding.fromJson(Map<String, Object> json) => _$PaddingFromJson(json);
  Map<String, Object> toJson() => _$PaddingToJson(this);

  @override
  void alignChild() {}
}
