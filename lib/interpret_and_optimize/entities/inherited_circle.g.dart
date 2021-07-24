// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_circle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedCircle _$InheritedCircleFromJson(Map<String, dynamic> json) {
  return InheritedCircle(
    originalRef: PBInheritedIntermediate.originalRefFromJson(
        json['originalRef'] as Map<String, dynamic>),
    bottomRightCorner: Point.bottomRightFromJson(
        json['bottomRightCorner'] as Map<String, dynamic>),
    topLeftCorner:
        Point.topLeftFromJson(json['topLeftCorner'] as Map<String, dynamic>),
    name: json['name'] as String,
    UUID: json['UUID'] as String,
    size: PBIntermediateNode.sizeFromJson(json['size'] as Map<String, dynamic>),
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNode'] as Map<String, dynamic>),
  )
    ..subsemantic = json['subsemantic'] as String
    ..children = (json['children'] as List)
        ?.map((e) => e == null
            ? null
            : PBIntermediateNode.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..child = json['child'] == null
        ? null
        : PBIntermediateNode.fromJson(json['child'] as Map<String, dynamic>)
    ..type = json['type'] as String;
}

Map<String, dynamic> _$InheritedCircleToJson(InheritedCircle instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'children': instance.children,
      'child': instance.child,
      'name': instance.name,
      'prototypeNode': instance.prototypeNode,
      'topLeftCorner': instance.topLeftCorner,
      'bottomRightCorner': instance.bottomRightCorner,
      'type': instance.type,
      'UUID': instance.UUID,
      'size': instance.size,
      'originalRef': instance.originalRef,
    };
