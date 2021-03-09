// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regular_polygon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaRegularPolygon _$FigmaRegularPolygonFromJson(Map<String, dynamic> json) {
  return FigmaRegularPolygon(
    name: json['name'] as String,
    type: json['type'] as String,
    pluginData: json['pluginData'],
    sharedPluginData: json['sharedPluginData'],
    style: json['style'],
    layoutAlign: json['layoutAlign'],
    constraints: json['constraints'],
    boundaryRectangle: json['absoluteBoundingBox'] == null
        ? null
        : Frame.fromJson(json['absoluteBoundingBox'] as Map<String, dynamic>),
    size: json['size'],
    strokes: json['strokes'],
    strokeWeight: json['strokeWeight'],
    strokeAlign: json['strokeAlign'],
    styles: json['styles'],
    prototypeNodeUUID: json['transitionNodeID'] as String,
    transitionDuration: json['transitionDuration'] as num,
    transitionEasing: json['transitionEasing'] as String,
  )
    ..UUID = json['id'] as String
    ..isVisible = json['visible'] as bool ?? true
    ..fillsList = json['fills'] as List
    ..imageReference = json['imageReference'] as String
    ..pbdfType = json['pbdfType'] as String;
}

Map<String, dynamic> _$FigmaRegularPolygonToJson(
        FigmaRegularPolygon instance) =>
    <String, dynamic>{
      'id': instance.UUID,
      'name': instance.name,
      'pluginData': instance.pluginData,
      'sharedPluginData': instance.sharedPluginData,
      'visible': instance.isVisible,
      'transitionNodeID': instance.prototypeNodeUUID,
      'transitionDuration': instance.transitionDuration,
      'transitionEasing': instance.transitionEasing,
      'style': instance.style,
      'layoutAlign': instance.layoutAlign,
      'constraints': instance.constraints,
      'absoluteBoundingBox': instance.boundaryRectangle,
      'size': instance.size,
      'strokes': instance.strokes,
      'strokeWeight': instance.strokeWeight,
      'strokeAlign': instance.strokeAlign,
      'styles': instance.styles,
      'fills': instance.fillsList,
      'type': instance.type,
      'imageReference': instance.imageReference,
      'pbdfType': instance.pbdfType,
    };
