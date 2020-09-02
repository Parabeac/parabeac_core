import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/image.dart';
import 'package:parabeac_core/input/entities/abstract_sketch_node_factory.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/objects/frame.dart';
import 'package:parabeac_core/input/entities/objects/image_ref.dart';
import 'package:parabeac_core/input/entities/style/style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_deny_list_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_plugin_list_helper.dart';

part 'bitmap.g.dart';

@JsonSerializable(nullable: false)

// title: Bitmap Layer
// description: Bitmap layers house a single image
class Bitmap extends SketchNode implements SketchNodeFactory, Image {
  @override
  @JsonKey(name: '_class')
  String CLASS_NAME = 'bitmap';
  final ImageRef image;
  final bool fillReplacesImage;
  final int intendedDPI;
  final dynamic clippingMask;

  Bitmap(
      {this.image,
      this.fillReplacesImage,
      this.intendedDPI,
      this.clippingMask,
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
      Bitmap.fromJson(json);
  factory Bitmap.fromJson(Map<String, dynamic> json) => _$BitmapFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BitmapToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    var intermediateNode;
    intermediateNode = PBDenyListHelper().returnDenyListNodeIfExist(this);
    if (intermediateNode != null) {
      return intermediateNode;
    }
    intermediateNode = PBPluginListHelper().returnAllowListNodeIfExists(this);
    if (intermediateNode != null) {
      return intermediateNode;
    }
    return Future.value(InheritedBitmap(this, currentContext: currentContext));
  }

  @override
  var designNode;

  @override
  @JsonKey(name: '_ref')
  //TODO: Discuss this with Eddie
  String imageReference;
}
