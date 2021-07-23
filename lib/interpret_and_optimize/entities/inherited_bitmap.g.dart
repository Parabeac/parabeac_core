// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_bitmap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedBitmap _$InheritedBitmapFromJson(Map<String, dynamic> json) {
  return InheritedBitmap(
    name: json['name'] as String,
    referenceImage: json['imageReference'] as String,
    bottomRightCorner: Point.bottomRightFromJson(
        json['bottomRightCorner'] as Map<String, dynamic>),
    topLeftCorner:
        Point.topLeftFromJson(json['topLeftCorner'] as Map<String, dynamic>),
    type: json['type'] as String,
    UUID: json['UUID'] as String,
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNode'] as Map<String, dynamic>),
    size: PBIntermediateNode.sizeFromJson(json['size'] as Map<String, dynamic>),
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

Map<String, dynamic> _$InheritedBitmapToJson(InheritedBitmap instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'children': instance.children,
      'child': instance.child,
      'name': instance.name,
      'prototypeNode': instance.prototypeNode,
      'imageReference': instance.referenceImage,
      'type': instance.type,
      'topLeftCorner': instance.topLeftCorner,
      'bottomRightCorner': instance.bottomRightCorner,
      'UUID': instance.UUID,
      'size': instance.size,
    };
