// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) {
  return Image(
    json['imageReference'] as String,
    json['designNode'] as DesignNode,
  );
}

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'imageReference': instance.imageReference,
      'name': instance.name,
    };
