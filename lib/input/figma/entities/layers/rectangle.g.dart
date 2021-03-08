// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rectangle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaRectangle _$FigmaRectangleFromJson(Map<String, dynamic> json) {
  return FigmaRectangle(
    name: json['name'] as String,
    isVisible: json['visible'] as bool ?? true,
    type: json['type'],
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
    cornerRadius: (json['cornerRadius'] as num)?.toDouble(),
    rectangleCornerRadii: (json['rectangleCornerRadii'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList(),
    points: json['points'] as List,
    fillsList: json['fills'] as List,
    prototypeNodeUUID: json['transitionNodeUUID'] as String,
    transitionDuration: json['transitionDuration'] as num,
    transitionEasing: json['transitionEasing'] as String,
  )
    ..UUID = json['id'] as String
    ..imageReference = json['imageReference'] as String
    ..pbdfType = json['pbdfType'] as String;
}

Map<String, dynamic> _$FigmaRectangleToJson(FigmaRectangle instance) =>
    <String, dynamic>{
      'id': instance.UUID,
      'name': instance.name,
      'pluginData': instance.pluginData,
      'sharedPluginData': instance.sharedPluginData,
      'visible': instance.isVisible,
      'transitionNodeUUID': instance.prototypeNodeUUID,
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
      'imageReference': instance.imageReference,
      'type': instance.type,
      'points': instance.points,
      'cornerRadius': instance.cornerRadius,
      'rectangleCornerRadii': instance.rectangleCornerRadii,
      'pbdfType': instance.pbdfType,
    };
