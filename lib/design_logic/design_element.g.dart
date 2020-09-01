// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DesignElement _$DesignElementFromJson(Map<String, dynamic> json) {
  return DesignElement(
    json['designNode'],
  )
    ..UUID = json['UUID'] as String
    ..name = json['name'] as String
    ..isVisible = json['isVisible'] as bool
    ..boundaryRectangle = json['boundaryRectangle']
    ..type = json['type'] as String
    ..style = json['style'];
}

Map<String, dynamic> _$DesignElementToJson(DesignElement instance) =>
    <String, dynamic>{
      'UUID': instance.UUID,
      'name': instance.name,
      'isVisible': instance.isVisible,
      'boundaryRectangle': instance.boundaryRectangle,
      'type': instance.type,
      'style': instance.style,
      'designNode': instance.designNode,
    };
