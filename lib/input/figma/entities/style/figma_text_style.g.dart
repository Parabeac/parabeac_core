// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'figma_text_style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaTextStyle _$FigmaTextStyleFromJson(Map<String, dynamic> json) {
  return FigmaTextStyle(
    fontColor: json['fontColor'] == null
        ? null
        : FigmaColor.fromJson(json['fontColor'] as Map<String, dynamic>),
    weight: json['weight'] as String,
  );
}

Map<String, dynamic> _$FigmaTextStyleToJson(FigmaTextStyle instance) =>
    <String, dynamic>{
      'fontColor': instance.fontColor,
      'weight': instance.weight,
    };
