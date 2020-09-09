// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symbol_master.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SymbolMaster _$SymbolMasterFromJson(Map<String, dynamic> json) {
  return SymbolMaster(
    hasClickThrough: json['hasClickThrough'] as bool,
    groupLayout: json['groupLayout'],
    layers: (json['layers'] as List)
        ?.map((e) =>
            e == null ? null : SketchNode.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    UUID: json['do_objectID'] as String,
    booleanOperation: json['booleanOperation'],
    exportOptions: json['exportOptions'],
    boundaryRectangle: json['frame'] == null
        ? null
        : Frame.fromJson(json['frame'] as Map<String, dynamic>),
    flow: json['flow'] == null
        ? null
        : Flow.fromJson(json['flow'] as Map<String, dynamic>),
    isFixedToViewport: json['isFixedToViewport'],
    isFlippedHorizontal: json['isFlippedHorizontal'],
    isFlippedVertical: json['isFlippedVertical'],
    isLocked: json['isLocked'],
    isVisible: json['isVisible'],
    layerListExpandedType: json['layerListExpandedType'],
    name: json['name'],
    nameIsFixed: json['nameIsFixed'],
    resizingConstraint: json['resizingConstraint'],
    resizingType: json['resizingType'],
    rotation: json['rotation'],
    sharedStyleID: json['sharedStyleID'],
    shouldBreakMaskChain: json['shouldBreakMaskChain'],
    hasClippingMask: json['hasClippingMask'],
    clippingMaskMode: json['clippingMaskMode'],
    userInfo: json['userInfo'],
    style: json['style'] == null
        ? null
        : Style.fromJson(json['style'] as Map<String, dynamic>),
    maintainScrollPosition: json['maintainScrollPosition'],
    backgroundColor: json['backgroundColor'] == null
        ? null
        : Color.fromJson(json['backgroundColor'] as Map<String, dynamic>),
    hasBackgroundColor: json['hasBackgroundColor'] as bool,
    horizontalRulerData: json['horizontalRulerData'],
    includeBackgroundColorInExport:
        json['includeBackgroundColorInExport'] as bool,
    includeInCloudUpload: json['includeInCloudUpload'] as bool,
    isFlowHome: json['isFlowHome'] as bool,
    resizesContent: json['resizesContent'] as bool,
    verticalRulerData: json['verticalRulerData'],
    includeBackgroundColorInInstance:
        json['includeBackgroundColorInInstance'] as bool,
    symbolID: json['symbolID'] as String,
    changeIdentifier: json['changeIdentifier'] as int,
    allowsOverrides: json['allowsOverrides'] as bool,
    overrideProperties: (json['overrideProperties'] as List)
        ?.map((e) => e == null
            ? null
            : OverridableProperty.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    presetDictionary: json['presetDictionary'],
  )
    ..CLASS_NAME = json['CLASS_NAME'] as String
    ..type = json['_class'] as String
    ..parameters = json['parameters'] as List;
}

Map<String, dynamic> _$SymbolMasterToJson(SymbolMaster instance) =>
    <String, dynamic>{
      'booleanOperation': instance.booleanOperation,
      'exportOptions': instance.exportOptions,
      'isFixedToViewport': instance.isFixedToViewport,
      'isFlippedHorizontal': instance.isFlippedHorizontal,
      'isFlippedVertical': instance.isFlippedVertical,
      'isLocked': instance.isLocked,
      'layerListExpandedType': instance.layerListExpandedType,
      'name': instance.name,
      'nameIsFixed': instance.nameIsFixed,
      'resizingConstraint': instance.resizingConstraint,
      'resizingType': instance.resizingType,
      'rotation': instance.rotation,
      'sharedStyleID': instance.sharedStyleID,
      'shouldBreakMaskChain': instance.shouldBreakMaskChain,
      'hasClippingMask': instance.hasClippingMask,
      'clippingMaskMode': instance.clippingMaskMode,
      'userInfo': instance.userInfo,
      'maintainScrollPosition': instance.maintainScrollPosition,
      'hasClickThrough': instance.hasClickThrough,
      'groupLayout': instance.groupLayout,
      'layers': instance.layers,
      'CLASS_NAME': instance.CLASS_NAME,
      'backgroundColor': instance.backgroundColor,
      'hasBackgroundColor': instance.hasBackgroundColor,
      'horizontalRulerData': instance.horizontalRulerData,
      'includeBackgroundColorInExport': instance.includeBackgroundColorInExport,
      'includeInCloudUpload': instance.includeInCloudUpload,
      'isFlowHome': instance.isFlowHome,
      'resizesContent': instance.resizesContent,
      'verticalRulerData': instance.verticalRulerData,
      'includeBackgroundColorInInstance':
          instance.includeBackgroundColorInInstance,
      'symbolID': instance.symbolID,
      'changeIdentifier': instance.changeIdentifier,
      'allowsOverrides': instance.allowsOverrides,
      'overrideProperties': instance.overrideProperties,
      'presetDictionary': instance.presetDictionary,
      'frame': instance.boundaryRectangle,
      'do_objectID': instance.UUID,
      '_class': instance.type,
      'isVisible': instance.isVisible,
      'style': instance.style,
      'parameters': instance.parameters,
    };
