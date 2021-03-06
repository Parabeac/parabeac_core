// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vector.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaVector _$FigmaVectorFromJson(Map<String, dynamic> json) {
  return FigmaVector(
    name: json['name'] as String,
    type: json['type'] as String,
    pluginData: json['pluginData'],
    sharedPluginData: json['sharedPluginData'],
    style: json['style'] == null
        ? null
        : FigmaStyle.fromJson(json['style'] as Map<String, dynamic>),
    layoutAlign: json['layoutAlign'] as String,
    constraints: json['constraints'],
    boundaryRectangle: json['absoluteBoundingBox'] == null
        ? null
        : Frame.fromJson(json['absoluteBoundingBox'] as Map<String, dynamic>),
    size: json['size'],
    strokes: json['strokes'],
    strokeWeight: (json['strokeWeight'] as num)?.toDouble(),
    strokeAlign: json['strokeAlign'] as String,
    styles: json['styles'],
    fillsList: json['fills'] as List,
    UUID: json['id'] as String,
    transitionDuration: json['transitionDuration'] as num,
    transitionEasing: json['transitionEasing'] as String,
    prototypeNodeUUID: json['transitionNodeUUID'] as String,
  )
    ..isVisible = json['visible'] as bool ?? true
    ..imageReference = json['imageReference'] as String
    ..pbdfType = json['pbdfType'] as String;
}

Map<String, dynamic> _$FigmaVectorToJson(FigmaVector instance) =>
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
      'type': instance.type,
      'fills': instance.fillsList,
      'imageReference': instance.imageReference,
      'pbdfType': instance.pbdfType,
    };
