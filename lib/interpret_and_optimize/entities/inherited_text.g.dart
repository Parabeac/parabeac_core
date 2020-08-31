// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedText _$InheritedTextFromJson(Map<String, dynamic> json) {
  return InheritedText(
    SketchNode.fromJson(json['originalRef'] as Map<String, dynamic>),
  )
    ..subsemantic = json['subsemantic'] as String
    ..child = json['child']
    ..topLeftCorner = json['topLeftCorner'] == null
        ? null
        : Point.fromJson(json['topLeftCorner'] as Map<String, dynamic>)
    ..bottomRightCorner = json['bottomRightCorner'] == null
        ? null
        : Point.fromJson(json['bottomRightCorner'] as Map<String, dynamic>)
    ..size = json['size'] as Map<String, dynamic>
    ..borderInfo = json['borderInfo'] as Map<String, dynamic>
    ..alignment = json['alignment'] as Map<String, dynamic>
    ..name = json['name'] as String
    ..color = json['color'] as String
    ..isTextParameter = json['isTextParameter'] as bool
    ..UUID = json['UUID'] as String
    ..text = json['text'] as String
    ..widgetType = json['widgetType'] as String
    ..fontSize = json['fontSize'] as num
    ..fontName = json['fontName'] as String
    ..weight = json['weight'] as String
    ..textAlignment = json['textAlignment'] as String;
}

Map<String, dynamic> _$InheritedTextToJson(InheritedText instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'child': instance.child,
      'topLeftCorner': instance.topLeftCorner,
      'bottomRightCorner': instance.bottomRightCorner,
      'size': instance.size,
      'borderInfo': instance.borderInfo,
      'alignment': instance.alignment,
      'name': instance.name,
      'color': instance.color,
      'isTextParameter': instance.isTextParameter,
      'UUID': instance.UUID,
      'originalRef': instance.originalRef,
      'text': instance.text,
      'widgetType': instance.widgetType,
      'fontSize': instance.fontSize,
      'fontName': instance.fontName,
      'weight': instance.weight,
      'textAlignment': instance.textAlignment,
    };
