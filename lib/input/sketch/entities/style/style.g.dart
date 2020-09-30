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
    UUID: json['do_objectID'] as String,
    endMarkerType: json['endMarkerType'] as int,
    miterLimit: json['miterLimit'] as int,
    startMarkerType: json['startMarkerType'] as int,
    windingRule: json['windingRule'] as int,
    textStyle: json['textStyle'] == null
        ? null
        : TextStyle.fromJson(json['textStyle'] as Map<String, dynamic>),
  )
    ..boundaryRectangle = json['boundaryRectangle']
    ..isVisible = json['isVisible'] as bool
    ..name = json['name'] as String
    ..prototypeNodeUUID = json['prototypeNodeUUID'] as String
    ..type = json['type'] as String;
}

Map<String, dynamic> _$StyleToJson(Style instance) => <String, dynamic>{
      '_class': instance.classField,
      'do_objectID': instance.UUID,
      'endMarkerType': instance.endMarkerType,
      'miterLimit': instance.miterLimit,
      'startMarkerType': instance.startMarkerType,
      'windingRule': instance.windingRule,
      'blur': instance.blur,
      'borderOptions': instance.borderOptions,
      'borders': instance.borders,
      'colorControls': instance.colorControls,
      'contextSettings': instance.contextSettings,
      'textStyle': instance.textStyle,
      'boundaryRectangle': instance.boundaryRectangle,
      'isVisible': instance.isVisible,
      'name': instance.name,
      'prototypeNodeUUID': instance.prototypeNodeUUID,
      'type': instance.type,
    };
