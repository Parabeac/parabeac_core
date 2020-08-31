// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Color _$ColorFromJson(Map<String, dynamic> json) {
  return Color(
    (json['alpha'] as num).toDouble(),
    (json['red'] as num).toDouble(),
    (json['green'] as num).toDouble(),
    (json['blue'] as num).toDouble(),
  );
}

Map<String, dynamic> _$ColorToJson(Color instance) => <String, dynamic>{
      'alpha': instance.alpha,
      'red': instance.red,
      'green': instance.green,
      'blue': instance.blue,
    };
