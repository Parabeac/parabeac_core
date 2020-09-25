// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rectangle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaRectangle _$FigmaRectangleFromJson(Map<String, dynamic> json) {
  return FigmaRectangle(
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
    cornerRadius: (json['cornerRadius'] as num)?.toDouble(),
    rectangleCornerRadii: (json['rectangleCornerRadii'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList(),
    points: json['points'] as List,
  )
    ..UUID = json['id'] as String
    ..isVisible = json['isVisible'] as bool
    ..prototypeNodeUUID = json['transitionNodeID'] as String;
}

Map<String, dynamic> _$FigmaRectangleToJson(FigmaRectangle instance) =>
    <String, dynamic>{
      'id': instance.UUID,
      'name': instance.name,
      'visible': instance.visible,
      'pluginData': instance.pluginData,
      'sharedPluginData': instance.sharedPluginData,
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
      'points': instance.points,
      'cornerRadius': instance.cornerRadius,
      'rectangleCornerRadii': instance.rectangleCornerRadii,
    };
