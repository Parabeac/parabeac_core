// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'figma_fill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaFill _$FigmaFillFromJson(Map<String, dynamic> json) {
  return FigmaFill(
    json['color'] == null
        ? null
        : FigmaColor.fromJson(json['color'] as Map<String, dynamic>),
    json['isEnabled'] as bool,
  );
}

Map<String, dynamic> _$FigmaFillToJson(FigmaFill instance) => <String, dynamic>{
      'color': instance.color,
      'isEnabled': instance.isEnabled,
    };
