// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Page _$PageFromJson(Map<String, dynamic> json) {
  return Page(
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
  )
    ..CLASS_NAME = json['CLASS_NAME'] as String
    ..includeInCloudUpload = json['includeInCloudUpload']
    ..horizontalRulerData = json['horizontalRulerData']
    ..verticalRulerData = json['verticalRulerData']
    ..layout = json['layout']
    ..grid = json['grid']
    ..type = json['_class'] as String;
}

Map<String, dynamic> _$PageToJson(Page instance) => <String, dynamic>{
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
      'includeInCloudUpload': instance.includeInCloudUpload,
      'horizontalRulerData': instance.horizontalRulerData,
      'verticalRulerData': instance.verticalRulerData,
      'layout': instance.layout,
      'grid': instance.grid,
      'frame': instance.boundaryRectangle,
      'do_objectID': instance.UUID,
      '_class': instance.type,
      'isVisible': instance.isVisible,
      'style': instance.style,
    };
