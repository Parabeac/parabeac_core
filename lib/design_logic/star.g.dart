// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'star.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Star _$StarFromJson(Map<String, dynamic> json) {
  return Star()
    ..UUID = json['UUID'] as String
    ..name = json['name'] as String
    ..isVisible = json['isVisible'] as bool
    ..boundaryRectangle = json['boundaryRectangle']
    ..type = json['type'] as String
    ..style = json['style']
    ..designNode = json['designNode'];
}

Map<String, dynamic> _$StarToJson(Star instance) => <String, dynamic>{
      'UUID': instance.UUID,
      'name': instance.name,
      'isVisible': instance.isVisible,
      'boundaryRectangle': instance.boundaryRectangle,
      'type': instance.type,
      'style': instance.style,
      'designNode': instance.designNode,
    };
