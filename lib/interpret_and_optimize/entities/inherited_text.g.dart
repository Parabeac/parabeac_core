// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedText _$InheritedTextFromJson(Map<String, dynamic> json) {
  return InheritedText(
    json['originalRef'],
    json['name'] as String,
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
    ..color = json['color'] as String
    ..isTextParameter = json['isTextParameter'] as bool
    ..UUID = json['UUID'] as String
    ..text = json['text'] as String
    ..widgetType = json['widgetType'] as String
    ..fontSize = json['fontSize'] as num
    ..fontName = json['fontName'] as String
    ..fontWeight = json['fontWeight'] as String
    ..fontStyle = json['fontStyle'] as String
    ..textAlignment = json['textAlignment'] as String
    ..letterSpacing = json['letterSpacing'] as num;
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
      'fontWeight': instance.fontWeight,
      'fontStyle': instance.fontStyle,
      'textAlignment': instance.textAlignment,
      'letterSpacing': instance.letterSpacing,
    };
