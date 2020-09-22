// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regular_polygon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaRegularPolygon _$FigmaRegularPolygonFromJson(Map<String, dynamic> json) {
  return FigmaRegularPolygon(
    name: json['name'] as String,
    visible: json['visible'] as bool,
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
    fills: json['fills'],
    strokes: json['strokes'],
    strokeWeight: json['strokeWeight'],
    strokeAlign: json['strokeAlign'],
    styles: json['styles'],
  )
    ..UUID = json['UUID'] as String
    ..isVisible = json['isVisible'] as bool
    ..prototypeNodeUUID = json['transitionNodeID'] as String;
}

Map<String, dynamic> _$FigmaRegularPolygonToJson(
        FigmaRegularPolygon instance) =>
    <String, dynamic>{
      'name': instance.name,
      'visible': instance.visible,
      'pluginData': instance.pluginData,
      'sharedPluginData': instance.sharedPluginData,
      'UUID': instance.UUID,
      'isVisible': instance.isVisible,
      'style': instance.style,
      'layoutAlign': instance.layoutAlign,
      'constraints': instance.constraints,
      'transitionNodeID': instance.prototypeNodeUUID,
      'absoluteBoundingBox': instance.boundaryRectangle,
      'size': instance.size,
      'fills': instance.fills,
      'strokes': instance.strokes,
      'strokeWeight': instance.strokeWeight,
      'strokeAlign': instance.strokeAlign,
      'styles': instance.styles,
      'type': instance.type,
    };
