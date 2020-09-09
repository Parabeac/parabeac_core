// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedContainer _$InheritedContainerFromJson(Map<String, dynamic> json) {
  return InheritedContainer(
    json['originalRef'],
    json['topLeftCorner'] == null
        ? null
        : Point.fromJson(json['topLeftCorner'] as Map<String, dynamic>),
    json['bottomRightCorner'] == null
        ? null
        : Point.fromJson(json['bottomRightCorner'] as Map<String, dynamic>),
    borderInfo: json['borderInfo'] as Map<String, dynamic>,
  )
    ..subsemantic = json['subsemantic'] as String
    ..child = json['child']
    ..name = json['name'] as String
    ..color = json['color'] as String
    ..widgetType = json['widgetType'] as String
    ..UUID = json['UUID'] as String
    ..size = json['size'] as Map<String, dynamic>
    ..alignment = json['alignment'] as Map<String, dynamic>;
}

Map<String, dynamic> _$InheritedContainerToJson(InheritedContainer instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'child': instance.child,
      'name': instance.name,
      'color': instance.color,
      'originalRef': instance.originalRef,
      'bottomRightCorner': instance.bottomRightCorner,
      'topLeftCorner': instance.topLeftCorner,
      'widgetType': instance.widgetType,
      'UUID': instance.UUID,
      'size': instance.size,
      'alignment': instance.alignment,
      'borderInfo': instance.borderInfo,
    };
