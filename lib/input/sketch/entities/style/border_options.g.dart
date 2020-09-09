// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'border_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BorderOptions _$BorderOptionsFromJson(Map<String, dynamic> json) {
  return BorderOptions(
    classField: json['_class'] as String,
    dashPattern: json['dashPattern'] as List,
    isEnabled: json['isEnabled'] as bool,
    lineCapStyle: json['lineCapStyle'] as int,
    lineJoinStyle: json['lineJoinStyle'] as int,
  );
}

Map<String, dynamic> _$BorderOptionsToJson(BorderOptions instance) =>
    <String, dynamic>{
      '_class': instance.classField,
      'isEnabled': instance.isEnabled,
      'dashPattern': instance.dashPattern,
      'lineCapStyle': instance.lineCapStyle,
      'lineJoinStyle': instance.lineJoinStyle,
    };
