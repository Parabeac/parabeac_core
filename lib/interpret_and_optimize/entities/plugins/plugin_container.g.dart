// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PluginContainer _$PluginContainerFromJson(Map<String, dynamic> json) {
  return PluginContainer(
    json['topLeftCorner'] == null
        ? null
        : Point.fromJson(json['topLeftCorner'] as Map<String, dynamic>),
    json['bottomRightCorner'] == null
        ? null
        : Point.fromJson(json['bottomRightCorner'] as Map<String, dynamic>),
    json['UUID'] as String,
    alignX: (json['alignX'] as num)?.toDouble(),
    alignY: (json['alignY'] as num)?.toDouble(),
    color: json['color'] as String,
  )
    ..name = json['name'] as String
    ..semanticName = json['semanticName'] as String
    ..subsemantic = json['subsemantic'] as String
    ..child = json['child']
    ..size = json['size'] as Map<String, dynamic>
    ..margins = json['margins'] as Map<String, dynamic>
    ..padding = json['padding'] as Map<String, dynamic>
    ..borderInfo = json['borderInfo'] as Map<String, dynamic>
    ..alignment = json['alignment'] as Map<String, dynamic>
    ..widgetType = json['widgetType'] as String;
}

Map<String, dynamic> _$PluginContainerToJson(PluginContainer instance) =>
    <String, dynamic>{
      'name': instance.name,
      'bottomRightCorner': instance.bottomRightCorner,
      'semanticName': instance.semanticName,
      'subsemantic': instance.subsemantic,
      'topLeftCorner': instance.topLeftCorner,
      'alignX': instance.alignX,
      'alignY': instance.alignY,
      'color': instance.color,
      'UUID': instance.UUID,
      'child': instance.child,
      'size': instance.size,
      'margins': instance.margins,
      'padding': instance.padding,
      'borderInfo': instance.borderInfo,
      'alignment': instance.alignment,
      'widgetType': instance.widgetType,
    };
