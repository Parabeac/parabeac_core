import 'package:parabeac_core/input/entities/abstract_sketch_node_factory.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/layers/abstract_shape_layer.dart';
import 'package:parabeac_core/input/entities/objects/frame.dart';
import 'package:parabeac_core/input/entities/style/style.dart';
import 'package:parabeac_core/input/helper/svg_png_convertion.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_shape_path.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:convert';
part 'shape_path.g.dart';

// title: Shape Path Layer
// description: Shape path layers are the result of adding a vector layer
@JsonSerializable(nullable: false)
class ShapePath extends AbstractShapeLayer implements SketchNodeFactory {
  @override
  @JsonKey(name: '_class')
  String CLASS_NAME = 'shapePath';

  @override
  @JsonKey(name: 'frame')
  var boundaryRectangle;
  ShapePath(
      {bool edited,
      bool isClosed,
      pointRadiusBehaviour,
      List points,
      do_objectID,
      booleanOperation,
      exportOptions,
      Frame this.boundaryRectangle,
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
            boundaryRectangle,
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
      ShapePath.fromJson(json);
  factory ShapePath.fromJson(Map<String, dynamic> json) =>
      _$ShapePathFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ShapePathToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) async {
    var image = await convertImageLocal(
        do_objectID, boundaryRectangle.width, boundaryRectangle.height);
    if (image == null) {
      return null;
    }
    return Future.value(
        InheritedShapePath(this, currentContext: currentContext, image: image));
  }

  @override
  var designNode;
}
