// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artboard _$ArtboardFromJson(Map<String, dynamic> json) {
  return Artboard(
    includeInCloudUpload: json['includeInCloudUpload'] as bool,
    includeBackgroundColorInExport:
        json['includeBackgroundColorInExport'] as bool,
    horizontalRulerData: json['horizontalRulerData'],
    verticalRulerData: json['verticalRulerData'],
    layout: json['layout'],
    grid: json['grid'],
    backgroundColor:
        Color.fromJson(json['backgroundColor'] as Map<String, dynamic>),
    hasBackgroundColor: json['hasBackgroundColor'] as bool,
    isFlowHome: json['isFlowHome'] as bool,
    resizesContent: json['resizesContent'] as bool,
    presetDictionary: json['presetDictionary'],
    hasClickThrough: json['hasClickThrough'],
    groupLayout: json['groupLayout'],
    children: (json['layers'] as List)
        .map((e) => SketchNode.fromJson(e as Map<String, dynamic>))
        .toList(),
    UUID: json['do_objectID'] as String,
    booleanOperation: json['booleanOperation'],
    exportOptions: json['exportOptions'],
    boundaryRectangle: Frame.fromJson(json['frame'] as Map<String, dynamic>),
    flow: json['flow'],
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
    style: Style.fromJson(json['style'] as Map<String, dynamic>),
    maintainScrollPosition: json['maintainScrollPosition'],
  )
    ..CLASS_NAME = json['CLASS_NAME'] as String
    ..type = json['_class'] as String;
}

Map<String, dynamic> _$ArtboardToJson(Artboard instance) => <String, dynamic>{
      'booleanOperation': instance.booleanOperation,
      'exportOptions': instance.exportOptions,
      'flow': instance.flow,
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
      'layers': instance.children,
      'CLASS_NAME': instance.CLASS_NAME,
      '_class': instance.type,
      'includeInCloudUpload': instance.includeInCloudUpload,
      'includeBackgroundColorInExport': instance.includeBackgroundColorInExport,
      'horizontalRulerData': instance.horizontalRulerData,
      'verticalRulerData': instance.verticalRulerData,
      'layout': instance.layout,
      'grid': instance.grid,
      'frame': instance.boundaryRectangle,
      'backgroundColor': instance.backgroundColor,
      'do_objectID': instance.UUID,
      'hasBackgroundColor': instance.hasBackgroundColor,
      'isFlowHome': instance.isFlowHome,
      'resizesContent': instance.resizesContent,
      'presetDictionary': instance.presetDictionary,
      'isVisible': instance.isVisible,
      'style': instance.style,
    };
