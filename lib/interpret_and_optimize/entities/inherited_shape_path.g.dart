// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_shape_path.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedShapePath _$InheritedShapePathFromJson(Map<String, dynamic> json) {
  return InheritedShapePath(
    name: json['name'] as String,
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNodeUUID'] as String),
    UUID: json['UUID'] as String,
    size: PBIntermediateNode.sizeFromJson(
        json['boundaryRectangle'] as Map<String, dynamic>),
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
    ..auxiliaryData = json['style'] == null
        ? null
        : IntermediateAuxiliaryData.fromJson(
            json['style'] as Map<String, dynamic>)
    ..type = json['type'] as String;
}

Map<String, dynamic> _$InheritedShapePathToJson(InheritedShapePath instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'children': instance.children,
      'child': instance.child,
      'style': instance.auxiliaryData,
      'name': instance.name,
      'prototypeNodeUUID': instance.prototypeNode,
      'type': instance.type,
      'UUID': instance.UUID,
      'boundaryRectangle': instance.size,
    };
