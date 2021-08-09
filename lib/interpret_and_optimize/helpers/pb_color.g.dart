// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBColor _$PBColorFromJson(Map<String, dynamic> json) {
  return PBColor(
    json['alpha'] as num,
    json['red'] as num,
    json['green'] as num,
    json['blue'] as num,
  );
}

Map<String, dynamic> _$PBColorToJson(PBColor instance) => <String, dynamic>{
      'alpha': instance.alpha,
      'red': instance.red,
      'green': instance.green,
      'blue': instance.blue,
    };
