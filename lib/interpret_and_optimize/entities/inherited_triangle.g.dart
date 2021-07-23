// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_triangle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedTriangle _$InheritedTriangleFromJson(Map<String, dynamic> json) {
  return InheritedTriangle(
    name: json['name'] as String,
    topLeftCorner:
        Point.topLeftFromJson(json['topLeftCorner'] as Map<String, dynamic>),
    bottomRightCorner: Point.bottomRightFromJson(
        json['bottomRightCorner'] as Map<String, dynamic>),
    UUID: json['UUID'] as String,
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNode'] as Map<String, dynamic>),
    size: PBIntermediateNode.sizeFromJson(json['size'] as Map<String, dynamic>),
    type: json['type'] as String,
  )
    ..subsemantic = json['subsemantic'] as String
    ..children = (json['children'] as List)
        ?.map((e) => e == null
            ? null
            : PBIntermediateNode.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..child = json['child'] == null
        ? null
        : PBIntermediateNode.fromJson(json['child'] as Map<String, dynamic>);
}

Map<String, dynamic> _$InheritedTriangleToJson(InheritedTriangle instance) =>
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
    };
