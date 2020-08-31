// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_shape.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DesignShape _$DesignShapeFromJson(Map<String, dynamic> json) {
  return DesignShape()
    ..UUID = json['UUID'] as String
    ..name = json['name'] as String
    ..isVisible = json['isVisible'] as bool
    ..boundaryRectangle = json['boundaryRectangle']
    ..type = json['type'] as String
    ..designNode = json['designNode'];
}

Map<String, dynamic> _$DesignShapeToJson(DesignShape instance) =>
    <String, dynamic>{
      'UUID': instance.UUID,
      'name': instance.name,
      'isVisible': instance.isVisible,
      'boundaryRectangle': instance.boundaryRectangle,
      'type': instance.type,
      'designNode': instance.designNode,
    };
