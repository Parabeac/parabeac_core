import 'package:parabeac_core/input/entities/abstract_sketch_node_factory.dart';
import 'package:parabeac_core/input/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/objects/frame.dart';
import 'package:parabeac_core/input/entities/style/style.dart';
import 'package:parabeac_core/input/helper/svg_png_convertion.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import '../../../interpret_and_optimize/entities/inherited_shape_group.dart';
import 'dart:convert';

part 'shape_group.g.dart';

// title: Shape Group Layer
// description: Shape groups layers group together multiple shape layers
@JsonSerializable(nullable: false)
class ShapeGroup extends AbstractGroupLayer implements SketchNodeFactory {
  @override
  @JsonKey(name: '_class')
  String CLASS_NAME = 'shapeGroup';
  final dynamic windingRule;

  ShapeGroup(
      {bool hasClickThrough,
      groupLayout,
      List<SketchNode> layers,
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
      maintainScrollPosition,
      this.windingRule})
      : super(
            hasClickThrough,
            groupLayout,
            layers,
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
      ShapeGroup.fromJson(json);
  factory ShapeGroup.fromJson(Map<String, dynamic> json) =>
      _$ShapeGroupFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ShapeGroupToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) async {
    var image = await convertImage(toJson());
    return InheritedShapeGroup(this,
        currentContext: currentContext, image: image);
  }
}
