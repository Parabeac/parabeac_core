// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Text _$TextFromJson(Map<String, dynamic> json) {
  return Text(
    json['content'] as String,
    json['designNode'],
  )
    ..UUID = json['UUID'] as String
    ..name = json['name'] as String
    ..isVisible = json['isVisible'] as bool
    ..boundaryRectangle = json['boundaryRectangle']
    ..type = json['type'] as String
    ..style = json['style'];
}

Map<String, dynamic> _$TextToJson(Text instance) => <String, dynamic>{
      'UUID': instance.UUID,
      'name': instance.name,
      'isVisible': instance.isVisible,
      'boundaryRectangle': instance.boundaryRectangle,
      'type': instance.type,
      'style': instance.style,
      'designNode': instance.designNode,
      'content': instance.content,
    };
