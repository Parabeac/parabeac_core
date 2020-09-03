import 'package:parabeac_core/input/entities/abstract_sketch_node_factory.dart';
import 'package:parabeac_core/input/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/objects/frame.dart';
import 'package:parabeac_core/input/entities/style/style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

part 'page.g.dart';

// title: Page Layer
// description:
//   Page layers are the top level organisational abstraction within a document
@JsonSerializable(nullable: false)
class Page extends AbstractGroupLayer implements SketchNodeFactory {
  @override
  @JsonKey(name: '_class')
  String CLASS_NAME = 'page';
  dynamic includeInCloudUpload;
  dynamic horizontalRulerData;
  dynamic verticalRulerData;
  dynamic layout;
  dynamic grid;

  @override
  @JsonKey(name: 'frame')
  var boundaryRectangle;

  Page(
      {bool hasClickThrough,
      groupLayout,
      List<SketchNode> layers,
      do_objectID,
      booleanOperation,
      exportOptions,
      Frame boundaryRectangle,
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
  SketchNode createSketchNode(Map<String, dynamic> json) => Page.fromJson(json);
  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PageToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    assert(false, 'We don\'t product pages as Intermediate Nodes.');
    return null;
  }
}
