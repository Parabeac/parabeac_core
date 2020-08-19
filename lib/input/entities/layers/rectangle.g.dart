// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rectangle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rectangle _$RectangleFromJson(Map<String, dynamic> json) {
  return Rectangle(
    fixedRadius: (json['fixedRadius'] as num).toDouble(),
    hasConvertedToNewRoundCorners:
        json['hasConvertedToNewRoundCorners'] as bool,
    needsConvertionToNewRoundCorners:
        json['needsConvertionToNewRoundCorners'] as bool,
    edited: json['edited'] as bool,
    isClosed: json['isClosed'] as bool,
    pointRadiusBehaviour: json['pointRadiusBehaviour'],
    points: json['points'] as List,
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
  );
}

Map<String, dynamic> _$RectangleToJson(Rectangle instance) => <String, dynamic>{
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
      'edited': instance.edited,
      'isClosed': instance.isClosed,
      'pointRadiusBehaviour': instance.pointRadiusBehaviour,
      'points': instance.points,
      'fixedRadius': instance.fixedRadius,
      'hasConvertedToNewRoundCorners': instance.hasConvertedToNewRoundCorners,
      'needsConvertionToNewRoundCorners':
          instance.needsConvertionToNewRoundCorners,
    };
