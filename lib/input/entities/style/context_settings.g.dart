// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContextSettings _$ContextSettingsFromJson(Map<String, dynamic> json) {
  return ContextSettings(
    blendMode: (json['blendMode'] as num)?.toDouble(),
    classField: json['_class'] as String,
    opacity: (json['opacity'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ContextSettingsToJson(ContextSettings instance) =>
    <String, dynamic>{
      '_class': instance.classField,
      'blendMode': instance.blendMode,
      'opacity': instance.opacity,
    };
