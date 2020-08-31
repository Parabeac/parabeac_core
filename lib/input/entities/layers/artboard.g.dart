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
    children: json['children'],
    do_objectID: json['do_objectID'],
    booleanOperation: json['booleanOperation'],
    exportOptions: json['exportOptions'],
    frame: Frame.fromJson(json['frame'] as Map<String, dynamic>),
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
    ..UUID = json['UUID'] as String
    ..boundaryRectangle = json['boundaryRectangle']
    ..type = json['type'] as String
    ..CLASS_NAME = json['_class'] as String
    ..designNode = json['designNode'];
}

Map<String, dynamic> _$ArtboardToJson(Artboard instance) => <String, dynamic>{
      'UUID': instance.UUID,
      'boundaryRectangle': instance.boundaryRectangle,
      'type': instance.type,
      'do_objectID': instance.do_objectID,
      'booleanOperation': instance.booleanOperation,
      'exportOptions': instance.exportOptions,
      'frame': instance.frame,
      'flow': instance.flow,
      'isFixedToViewport': instance.isFixedToViewport,
      'isFlippedHorizontal': instance.isFlippedHorizontal,
      'isFlippedVertical': instance.isFlippedVertical,
      'isLocked': instance.isLocked,
      'isVisible': instance.isVisible,
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
      'style': instance.style,
      'maintainScrollPosition': instance.maintainScrollPosition,
      'hasClickThrough': instance.hasClickThrough,
      'groupLayout': instance.groupLayout,
      '_class': instance.CLASS_NAME,
      'includeInCloudUpload': instance.includeInCloudUpload,
      'includeBackgroundColorInExport': instance.includeBackgroundColorInExport,
      'horizontalRulerData': instance.horizontalRulerData,
      'verticalRulerData': instance.verticalRulerData,
      'layout': instance.layout,
      'grid': instance.grid,
      'backgroundColor': instance.backgroundColor,
      'hasBackgroundColor': instance.hasBackgroundColor,
      'isFlowHome': instance.isFlowHome,
      'resizesContent': instance.resizesContent,
      'presetDictionary': instance.presetDictionary,
      'children': instance.children,
      'designNode': instance.designNode,
    };
