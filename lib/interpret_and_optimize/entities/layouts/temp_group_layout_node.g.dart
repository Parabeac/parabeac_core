// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temp_group_layout_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TempGroupLayoutNode _$TempGroupLayoutNodeFromJson(Map<String, dynamic> json) {
  return TempGroupLayoutNode(
    originalRef: PBInheritedIntermediate.originalRefFromJson(
        json['originalRef'] as Map<String, dynamic>),
    name: json['name'] as String,
    topLeftCorner:
        Point.topLeftFromJson(json['topLeftCorner'] as Map<String, dynamic>),
    bottomRightCorner: Point.bottomRightFromJson(
        json['bottomRightCorner'] as Map<String, dynamic>),
    UUID: json['UUID'] as String,
    children: (json['children'] as List)
        ?.map((e) => e == null
            ? null
            : PBIntermediateNode.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNode'] as Map<String, dynamic>),
    size: PBIntermediateNode.sizeFromJson(json['size'] as Map<String, dynamic>),
    type: json['type'] as String,
  )
    ..subsemantic = json['subsemantic'] as String
    ..child = json['child'] == null
        ? null
        : PBIntermediateNode.fromJson(json['child'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TempGroupLayoutNodeToJson(
        TempGroupLayoutNode instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'child': instance.child?.toJson(),
      'name': instance.name,
      'children': instance.children?.map((e) => e?.toJson())?.toList(),
      'prototypeNode': instance.prototypeNode?.toJson(),
      'type': instance.type,
      'UUID': instance.UUID,
      'topLeftCorner': instance.topLeftCorner?.toJson(),
      'bottomRightCorner': instance.bottomRightCorner?.toJson(),
      'size': instance.size,
      'originalRef': instance.originalRef,
    };
