// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'figma_color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaColor _$FigmaColorFromJson(Map<String, dynamic> json) {
  return FigmaColor(
    alpha: (json['a'] as num)?.toDouble(),
    red: (json['r'] as num)?.toDouble(),
    green: (json['g'] as num)?.toDouble(),
    blue: (json['b'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$FigmaColorToJson(FigmaColor instance) =>
    <String, dynamic>{
      'a': instance.alpha,
      'b': instance.blue,
      'g': instance.green,
      'r': instance.red,
    };
