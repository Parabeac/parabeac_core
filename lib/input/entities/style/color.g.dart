// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Color _$ColorFromJson(Map<String, dynamic> json) {
  return Color(
    alpha: (json['alpha'] as num)?.toDouble(),
    blue: (json['blue'] as num)?.toDouble(),
    classField: json['_class'] as String,
    green: (json['green'] as num)?.toDouble(),
    red: (json['red'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ColorToJson(Color instance) => <String, dynamic>{
      '_class': instance.classField,
      'alpha': instance.alpha,
      'blue': instance.blue,
      'green': instance.green,
      'red': instance.red,
    };
