import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/entities/abstract_sketch_node_factory.dart';
import 'package:parabeac_core/input/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/objects/frame.dart';
import 'package:parabeac_core/input/entities/style/color.dart';
import 'package:parabeac_core/input/entities/style/style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

part 'artboard.g.dart';

@JsonSerializable(nullable: false)
class Artboard extends AbstractGroupLayer implements SketchNodeFactory {
  @override
  @JsonKey(ignore: true)
  String CLASS_NAME = 'artboard';
  final bool includeInCloudUpload;
  final bool includeBackgroundColorInExport;
  final dynamic horizontalRulerData;
  final dynamic verticalRulerData;
  final dynamic layout;
  final dynamic grid;
  final Color backgroundColor;
  final bool hasBackgroundColor;
  final bool isFlowHome;
  final bool resizesContent;
  final dynamic presetDictionary;
  Artboard(
      {this.includeInCloudUpload,
      this.includeBackgroundColorInExport,
      this.horizontalRulerData,
      this.verticalRulerData,
      this.layout,
      this.grid,
      this.backgroundColor,
      this.hasBackgroundColor,
      this.isFlowHome,
      this.resizesContent,
      this.presetDictionary,
      hasClickThrough,
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
      maintainScrollPosition})
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
      Artboard.fromJson(json);
  factory Artboard.fromJson(Map<String, dynamic> json) =>
      _$ArtboardFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ArtboardToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    return Future.value(
        InheritedScaffold(this, currentContext: currentContext, name: name));
  }
}
