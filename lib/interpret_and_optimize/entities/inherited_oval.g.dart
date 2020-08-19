// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_oval.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedOval _$InheritedOvalFromJson(Map<String, dynamic> json) {
  return InheritedOval(
    SketchNode.fromJson(json['originalRef'] as Map<String, dynamic>),
  )
    ..subsemantic = json['subsemantic'] as String
    ..topLeftCorner =
        Point.fromJson(json['topLeftCorner'] as Map<String, dynamic>)
    ..bottomRightCorner =
        Point.fromJson(json['bottomRightCorner'] as Map<String, dynamic>)
    ..borderInfo = json['borderInfo'] as Map<String, dynamic>
    ..alignment = json['alignment'] as Map<String, dynamic>
    ..child = json['child']
    ..color = json['color'] as String
    ..name = json['name'] as String
    ..UUID = json['UUID'] as String
    ..size = json['size'] as Map<String, dynamic>
    ..referenceImage = json['referenceImage'] as String
    ..widgetType = json['widgetType'] as String;
}

Map<String, dynamic> _$InheritedOvalToJson(InheritedOval instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'topLeftCorner': instance.topLeftCorner,
      'bottomRightCorner': instance.bottomRightCorner,
      'borderInfo': instance.borderInfo,
      'alignment': instance.alignment,
      'child': instance.child,
      'color': instance.color,
      'originalRef': instance.originalRef,
      'name': instance.name,
      'UUID': instance.UUID,
      'size': instance.size,
      'referenceImage': instance.referenceImage,
      'widgetType': instance.widgetType,
    };
