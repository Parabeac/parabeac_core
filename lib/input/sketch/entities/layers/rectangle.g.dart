// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rectangle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rectangle _$RectangleFromJson(Map<String, dynamic> json) {
  return Rectangle(
    fixedRadius: (json['fixedRadius'] as num)?.toDouble(),
    hasConvertedToNewRoundCorners:
        json['hasConvertedToNewRoundCorners'] as bool,
    needsConvertionToNewRoundCorners:
        json['needsConvertionToNewRoundCorners'] as bool,
    edited: json['edited'] as bool,
    isClosed: json['isClosed'] as bool,
    pointRadiusBehaviour: json['pointRadiusBehaviour'],
    points: json['points'] as List,
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
    ..type = json['type'] as String
    ..prototypeNodeUUID = json['prototypeNodeUUID'] as String
    ..CLASS_NAME = json['_class'] as String
    ..designNode = json['designNode'];
}

Map<String, dynamic> _$RectangleToJson(Rectangle instance) => <String, dynamic>{
      'type': instance.type,
      'prototypeNodeUUID': instance.prototypeNodeUUID,
      'booleanOperation': instance.booleanOperation,
      'exportOptions': instance.exportOptions,
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
      '_class': instance.CLASS_NAME,
      'fixedRadius': instance.fixedRadius,
      'hasConvertedToNewRoundCorners': instance.hasConvertedToNewRoundCorners,
      'needsConvertionToNewRoundCorners':
          instance.needsConvertionToNewRoundCorners,
      'frame': instance.boundaryRectangle,
      'flow': instance.flow,
      'do_objectID': instance.UUID,
      'designNode': instance.designNode,
    };
