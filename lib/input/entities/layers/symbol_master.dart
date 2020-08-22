import 'package:parabeac_core/input/entities/abstract_sketch_node_factory.dart';
import 'package:parabeac_core/input/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/objects/frame.dart';
import 'package:parabeac_core/input/entities/objects/override_property.dart';
import 'package:parabeac_core/input/entities/style/color.dart';
import 'package:parabeac_core/input/entities/style/style.dart';
import 'package:parabeac_core/input/helper/symbol_node_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
part 'symbol_master.g.dart';

// title: Symbol Master Layer
// description: A symbol master layer represents a reusable group of layers
@JsonSerializable(nullable: false)
class SymbolMaster extends AbstractGroupLayer
    with SymbolNodeMixin
    implements SketchNodeFactory {
  @override
  @JsonKey(name: '_class')
  String CLASS_NAME = 'symbolMaster';
  final Color backgroundColor;
  final bool hasBackgroundColor;
  final dynamic horizontalRulerData;
  final bool includeBackgroundColorInExport;
  final bool includeInCloudUpload;
  final bool isFlowHome;
  final bool resizesContent;
  final dynamic verticalRulerData;
  final bool includeBackgroundColorInInstance;
  final dynamic symbolID;
  final int changeIdentifier;
  final bool allowsOverridess;
  final List<OverridableProperty> overrideProperties;
  final dynamic presetDictionary;

  SymbolMaster(
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
      this.backgroundColor,
      this.hasBackgroundColor,
      this.horizontalRulerData,
      this.includeBackgroundColorInExport,
      this.includeInCloudUpload,
      this.isFlowHome,
      this.resizesContent,
      this.verticalRulerData,
      this.includeBackgroundColorInInstance,
      this.symbolID,
      this.changeIdentifier,
      this.allowsOverridess,
      this.overrideProperties,
      this.presetDictionary})
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
            maintainScrollPosition) {
    this.name = name
        ?.replaceAll(RegExp(r'[\W]'), '')
        ?.replaceFirst(RegExp(r'^([\d]|_)+'), '');
  }

  @override
  SketchNode createSketchNode(Map<String, dynamic> json) =>
      SymbolMaster.fromJson(json);
  factory SymbolMaster.fromJson(Map<String, dynamic> json) =>
      _$SymbolMasterFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SymbolMasterToJson(this);

  ///Converting the [OverridableProperty] into [PBSharedParameterProp] to be processed in intermediate phase.
  List<PBSharedParameterProp> _extractParameters() =>
      overrideProperties?.map((prop) {
        var properties = extractParameter(prop.overrideName);
        return PBSharedParameterProp(
            properties[0], null, prop.canOverride, name, properties[1]);
      })?.toList();

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    var sym_master = PBSharedMasterNode(
      this,
      symbolID,
      name,
      Point(frame.x, frame.y),
      Point(frame.x + frame.width, frame.y + frame.height),
      overridableProperties: _extractParameters(),
      currentContext: currentContext,
    );
    return Future.value(sym_master);
  }
}
