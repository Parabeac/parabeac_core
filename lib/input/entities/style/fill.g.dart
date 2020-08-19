// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fill _$FillFromJson(Map<String, dynamic> json) {
  return Fill(
    classField: json['_class'] as String,
    color: json['color'] == null
        ? null
        : Color.fromJson(json['color'] as Map<String, dynamic>),
    contextSettings: json['contextSettings'] == null
        ? null
        : ContextSettings.fromJson(
            json['contextSettings'] as Map<String, dynamic>),
    fillType: json['fillType'] as int,
    gradient: json['gradient'] == null
        ? null
        : Gradient.fromJson(json['gradient'] as Map<String, dynamic>),
    isEnabled: json['isEnabled'] as bool,
    noiseIndex: json['noiseIndex'] as int,
    noiseIntensity: json['noiseIntensity'] as int,
    patternFillType: json['patternFillType'] as int,
    patternTileScale: json['patternTileScale'] as int,
  );
}

Map<String, dynamic> _$FillToJson(Fill instance) => <String, dynamic>{
      '_class': instance.classField,
      'isEnabled': instance.isEnabled,
      'fillType': instance.fillType,
      'color': instance.color,
      'contextSettings': instance.contextSettings,
      'gradient': instance.gradient,
      'noiseIndex': instance.noiseIndex,
      'noiseIntensity': instance.noiseIntensity,
      'patternFillType': instance.patternFillType,
      'patternTileScale': instance.patternTileScale,
    };
