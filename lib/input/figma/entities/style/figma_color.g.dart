// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'figma_color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaColor _$FigmaColorFromJson(Map<String, dynamic> json) {
  return FigmaColor(
    alpha: (json['alpha'] as num)?.toDouble(),
    red: (json['red'] as num)?.toDouble(),
    green: (json['green'] as num)?.toDouble(),
    blue: (json['blue'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$FigmaColorToJson(FigmaColor instance) =>
    <String, dynamic>{
      'alpha': instance.alpha,
      'blue': instance.blue,
      'green': instance.green,
      'red': instance.red,
    };
