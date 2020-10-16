// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextStyle _$TextStyleFromJson(Map<String, dynamic> json) {
  return TextStyle(
    rawEncodedAttributes: json['encodedAttributes'] as Map<String, dynamic>,
  )
    ..fontFamily = json['fontFamily'] as String
    ..fontSize = json['fontSize'] as String
    ..fontWeight = json['fontWeight'] as String
    ..weight = json['weight'] as String;
}

Map<String, dynamic> _$TextStyleToJson(TextStyle instance) => <String, dynamic>{
      'encodedAttributes': instance.rawEncodedAttributes,
      'fontFamily': instance.fontFamily,
      'fontSize': instance.fontSize,
      'fontWeight': instance.fontWeight,
      'weight': instance.weight,
    };
