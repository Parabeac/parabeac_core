// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_circle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedCircle _$InheritedCircleFromJson(Map<String, dynamic> json) {
  return InheritedCircle(
    DesignNode.fromJson(json['originalRef'] as Map<String, dynamic>),
    Point.fromJson(json['bottomRightCorner'] as Map<String, dynamic>),
    Point.fromJson(json['topLeftCorner'] as Map<String, dynamic>),
  )
    ..subsemantic = json['subsemantic'] as String
    ..child = json['child']
    ..name = json['name'] as String
    ..color = json['color'] as String
    ..UUID = json['UUID'] as String
    ..size = json['size'] as Map<String, dynamic>
    ..borderInfo = json['borderInfo'] as Map<String, dynamic>
    ..widgetType = json['widgetType'] as String
    ..alignment = json['alignment'] as Map<String, dynamic>;
}

Map<String, dynamic> _$InheritedCircleToJson(InheritedCircle instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'child': instance.child,
      'name': instance.name,
      'color': instance.color,
      'originalRef': instance.originalRef,
      'bottomRightCorner': instance.bottomRightCorner,
      'topLeftCorner': instance.topLeftCorner,
      'UUID': instance.UUID,
      'size': instance.size,
      'borderInfo': instance.borderInfo,
      'widgetType': instance.widgetType,
      'alignment': instance.alignment,
    };
