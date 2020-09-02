// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBArtboard _$PBArtboardFromJson(Map<String, dynamic> json) {
  return PBArtboard(
    json['backgroundColor'],
  )
    ..UUID = json['UUID'] as String
    ..name = json['name'] as String
    ..isVisible = json['isVisible'] as bool
    ..boundaryRectangle = json['boundaryRectangle']
    ..type = json['type'] as String
    ..style = json['style']
    ..designNode = json['designNode']
    ..children = json['children'] as List;
}

Map<String, dynamic> _$PBArtboardToJson(PBArtboard instance) =>
    <String, dynamic>{
      'UUID': instance.UUID,
      'name': instance.name,
      'isVisible': instance.isVisible,
      'boundaryRectangle': instance.boundaryRectangle,
      'type': instance.type,
      'style': instance.style,
      'designNode': instance.designNode,
      'backgroundColor': instance.backgroundColor,
      'children': instance.children,
    };
