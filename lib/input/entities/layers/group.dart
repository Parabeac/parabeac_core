import 'package:parabeac_core/input/entities/abstract_sketch_node_factory.dart';
import 'package:parabeac_core/input/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/objects/frame.dart';
import 'package:parabeac_core/input/entities/style/style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

part 'group.g.dart';

@JsonSerializable(nullable: false)
class Group extends AbstractGroupLayer implements SketchNodeFactory {
  @override
  @JsonKey(name: '_class')
  String CLASS_NAME = 'group';
  @override
  @JsonKey(name: 'frame')
  var boundaryRectangle;
  Group(
      {bool hasClickThrough,
      groupLayout,
      List<SketchNode> layers,
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
            hasClickThrough,
            groupLayout,
            layers,
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
      _$GroupFromJson(json);
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GroupToJson(this);
  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) =>
      Future.value(TempGroupLayoutNode(this, currentContext,
          topLeftCorner: Point(boundaryRectangle.x, boundaryRectangle.y),
          bottomRightCorner: Point(
              boundaryRectangle.x + boundaryRectangle.width,
              boundaryRectangle.y + boundaryRectangle.height)));
}
