import 'package:parabeac_core/input/entities/abstract_sketch_node_factory.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/layers/abstract_shape_layer.dart';
import 'package:parabeac_core/input/entities/objects/frame.dart';
import 'package:parabeac_core/input/entities/style/border.dart';
import 'package:parabeac_core/input/entities/style/style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

part 'rectangle.g.dart';

// title: Rectangle Layer
// description:
//   Rectangle layers are the result of adding a rectangle shape to the canvas
@JsonSerializable(nullable: false)
class Rectangle extends AbstractShapeLayer implements SketchNodeFactory {
  @override
  @JsonKey(ignore: true)
  String CLASS_NAME = 'rectangle';
  final double fixedRadius;
  final bool hasConvertedToNewRoundCorners;
  final bool needsConvertionToNewRoundCorners;
  Rectangle(
      {this.fixedRadius,
      this.hasConvertedToNewRoundCorners,
      this.needsConvertionToNewRoundCorners,
      bool edited,
      bool isClosed,
      pointRadiusBehaviour,
      List points,
      do_objectID,
      booleanOperation,
      exportOptions,
      Frame frame,
      flow,
      isFixedToViewport,
      isFlippedHorizontal,
      isFlippedVertical,
      isLocked,
      isVisible,
      layerListExpandedType,
      name,
      nameIsFixed,
      resizingConstraint,
      resizingType,
      rotation,
      sharedStyleID,
      shouldBreakMaskChain,
      hasClippingMask,
      clippingMaskMode,
      userInfo,
      Style style,
      maintainScrollPosition})
      : super(
            edited,
            isClosed,
            pointRadiusBehaviour,
            points,
            do_objectID,
            booleanOperation,
            exportOptions,
            frame,
            flow,
            isFixedToViewport,
            isFlippedHorizontal,
            isFlippedVertical,
            isLocked,
            isVisible,
            layerListExpandedType,
            name,
            nameIsFixed,
            resizingConstraint,
            resizingType,
            rotation,
            sharedStyleID,
            shouldBreakMaskChain,
            hasClippingMask,
            clippingMaskMode,
            userInfo,
            style,
            maintainScrollPosition);

  @override
  SketchNode createSketchNode(Map<String, dynamic> json) =>
      Rectangle.fromJson(json);
  factory Rectangle.fromJson(Map<String, dynamic> json) =>
      _$RectangleFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$RectangleToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    Border border;
    for (var b in style.borders.reversed) {
      if (b.isEnabled) {
        border = b;
      }
    }
    return Future.value(InheritedContainer(
      this,
      Point(frame.x, frame.y),
      Point(frame.x + frame.width, frame.y + frame.height),
      currentContext: currentContext,
      borderInfo: {
        'borderRadius':
            style.borderOptions.isEnabled ? points[0]['cornerRadius'] : null,
        'borderColorHex': border != null ? border.color.toHex() : null
      },
    ));
  }
}
