// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'figma_style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaStyle _$FigmaStyleFromJson(Map<String, dynamic> json) {
  return FigmaStyle(
    backgroundColor: json['backgroundColor'] == null
        ? null
        : FigmaColor.fromJson(json['backgroundColor'] as Map<String, dynamic>),
    borders: (json['borders'] as List)
        ?.map((e) =>
            e == null ? null : FigmaBorder.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    fills: (json['fills'] as List)
        ?.map((e) =>
            e == null ? null : FigmaFill.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    textStyle: json['textStyle'] == null
        ? null
        : FigmaTextStyle.fromJson(json['textStyle'] as Map<String, dynamic>),
    borderOptions: json['borderOptions'] == null
        ? null
        : FigmaBorderOptions.fromJson(
            json['borderOptions'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FigmaStyleToJson(FigmaStyle instance) =>
    <String, dynamic>{
      'backgroundColor': instance.backgroundColor,
      'fills': instance.fills,
      'borders': instance.borders,
      'textStyle': instance.textStyle,
      'borderOptions': instance.borderOptions,
    };
