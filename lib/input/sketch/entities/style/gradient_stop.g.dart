// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gradient_stop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradientStop _$GradientStopFromJson(Map<String, dynamic> json) {
  return GradientStop(
    classField: json['_class'] as String,
    color: json['color'] == null
        ? null
        : Color.fromJson(json['color'] as Map<String, dynamic>),
    position: (json['position'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$GradientStopToJson(GradientStop instance) =>
    <String, dynamic>{
      '_class': instance.classField,
      'position': instance.position,
      'color': instance.color,
    };
