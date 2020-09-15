// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Style _$StyleFromJson(Map<String, dynamic> json) {
  return Style(
    blur: json['blur'] == null
        ? null
        : Blur.fromJson(json['blur'] as Map<String, dynamic>),
    borderOptions: json['borderOptions'] == null
        ? null
        : BorderOptions.fromJson(json['borderOptions'] as Map<String, dynamic>),
    borders: (json['borders'] as List)
        ?.map((e) =>
            e == null ? null : Border.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    classField: json['_class'] as String,
    colorControls: json['colorControls'] == null
        ? null
        : ColorControls.fromJson(json['colorControls'] as Map<String, dynamic>),
    contextSettings: json['contextSettings'] == null
        ? null
        : ContextSettings.fromJson(
            json['contextSettings'] as Map<String, dynamic>),
    do_objectID: json['do_objectID'] as String,
    endMarkerType: json['endMarkerType'] as int,
    fills: (json['fills'] as List)
        ?.map(
            (e) => e == null ? null : Fill.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    innerShadows: (json['innerShadows'] as List)
        ?.map(
            (e) => e == null ? null : Fill.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    miterLimit: json['miterLimit'] as int,
    shadows: (json['shadows'] as List)
        ?.map(
            (e) => e == null ? null : Fill.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    startMarkerType: json['startMarkerType'] as int,
    windingRule: json['windingRule'] as int,
    textStyle: json['textStyle'] == null
        ? null
        : TextStyle.fromJson(json['textStyle'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StyleToJson(Style instance) => <String, dynamic>{
      '_class': instance.classField,
      'do_objectID': instance.do_objectID,
      'endMarkerType': instance.endMarkerType,
      'miterLimit': instance.miterLimit,
      'startMarkerType': instance.startMarkerType,
      'windingRule': instance.windingRule,
      'blur': instance.blur,
      'borderOptions': instance.borderOptions,
      'borders': instance.borders,
      'colorControls': instance.colorControls,
      'contextSettings': instance.contextSettings,
      'fills': instance.fills,
      'innerShadows': instance.innerShadows,
      'shadows': instance.shadows,
      'textStyle': instance.textStyle,
    };
