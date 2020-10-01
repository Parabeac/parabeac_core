// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'figma_border_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaBorderOptions _$FigmaBorderOptionsFromJson(Map<String, dynamic> json) {
  return FigmaBorderOptions(
    json['dashPattern'] as List,
    json['isEnabled'] as bool,
    json['lineCapStyle'] as int,
    json['lineJoinStyle'] as int,
  );
}

Map<String, dynamic> _$FigmaBorderOptionsToJson(FigmaBorderOptions instance) =>
    <String, dynamic>{
      'dashPattern': instance.dashPattern,
      'isEnabled': instance.isEnabled,
      'lineCapStyle': instance.lineCapStyle,
      'lineJoinStyle': instance.lineJoinStyle,
    };
