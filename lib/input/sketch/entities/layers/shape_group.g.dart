// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shape_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShapeGroup _$ShapeGroupFromJson(Map<String, dynamic> json) {
  return ShapeGroup(
    hasClickThrough: json['hasClickThrough'] as bool,
    groupLayout: json['groupLayout'],
    layers: (json['layers'] as List)
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
    windingRule: json['windingRule'],
  )
    ..type = json['type'] as String
    ..CLASS_NAME = json['_class'] as String;
}

Map<String, dynamic> _$ShapeGroupToJson(ShapeGroup instance) =>
    <String, dynamic>{
      'type': instance.type,
      'booleanOperation': instance.booleanOperation,
      'exportOptions': instance.exportOptions,
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
      'layers': instance.layers,
      '_class': instance.CLASS_NAME,
      'windingRule': instance.windingRule,
      'frame': instance.boundaryRectangle,
      'do_objectID': instance.UUID,
    };
