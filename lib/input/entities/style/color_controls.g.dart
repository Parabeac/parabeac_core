// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_controls.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorControls _$ColorControlsFromJson(Map<String, dynamic> json) {
  return ColorControls(
    brightness: (json['brightness'] as num)?.toDouble(),
    classField: json['_class'] as String,
    contrast: (json['contrast'] as num)?.toDouble(),
    hue: (json['hue'] as num)?.toDouble(),
    isEnabled: json['isEnabled'] as bool,
    saturation: (json['saturation'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ColorControlsToJson(ColorControls instance) =>
    <String, dynamic>{
      '_class': instance.classField,
      'isEnabled': instance.isEnabled,
      'brightness': instance.brightness,
      'contrast': instance.contrast,
      'hue': instance.hue,
      'saturation': instance.saturation,
    };
