// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injected_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InjectedContainer _$InjectedContainerFromJson(Map<String, dynamic> json) {
  return InjectedContainer(
    json['bottomRightCorner'] == null
        ? null
        : Point.fromJson(json['bottomRightCorner'] as Map<String, dynamic>),
    json['topLeftCorner'] == null
        ? null
        : Point.fromJson(json['topLeftCorner'] as Map<String, dynamic>),
    json['UUID'] as String,
    alignX: (json['alignX'] as num).toDouble(),
    alignY: (json['alignY'] as num).toDouble(),
    color: json['color'] as String,
  )
    ..subsemantic = json['subsemantic'] as String
    ..name = json['name'] as String
    ..child = json['child']
    ..size = json['size'] as Map<String, dynamic>
    ..margins = json['margins'] as Map<String, dynamic>
    ..padding = json['padding'] as Map<String, dynamic>
    ..borderInfo = json['borderInfo'] as Map<String, dynamic>
    ..alignment = json['alignment'] as Map<String, dynamic>
    ..widgetType = json['widgetType'] as String;
}

Map<String, dynamic> _$InjectedContainerToJson(InjectedContainer instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'topLeftCorner': instance.topLeftCorner,
      'bottomRightCorner': instance.bottomRightCorner,
      'name': instance.name,
      'alignX': instance.alignX,
      'alignY': instance.alignY,
      'color': instance.color,
      'child': instance.child,
      'size': instance.size,
      'margins': instance.margins,
      'padding': instance.padding,
      'borderInfo': instance.borderInfo,
      'alignment': instance.alignment,
      'UUID': instance.UUID,
      'widgetType': instance.widgetType,
    };
