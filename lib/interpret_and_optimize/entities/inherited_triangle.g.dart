// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_triangle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedTriangle _$InheritedTriangleFromJson(Map<String, dynamic> json) {
  return InheritedTriangle(
    json['UUID'] as String,
    DeserializedRectangle.fromJson(
        json['boundaryRectangle'] as Map<String, dynamic>),
    name: json['name'] as String,
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNodeUUID'] as String),
  )
    ..subsemantic = json['subsemantic'] as String
    ..auxiliaryData = json['style'] == null
        ? null
        : IntermediateAuxiliaryData.fromJson(
            json['style'] as Map<String, dynamic>)
    ..type = json['type'] as String;
}

Map<String, dynamic> _$InheritedTriangleToJson(InheritedTriangle instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'UUID': instance.UUID,
      'boundaryRectangle': DeserializedRectangle.toJson(instance.frame),
      'style': instance.auxiliaryData,
      'name': instance.name,
      'prototypeNodeUUID': instance.prototypeNode,
      'type': instance.type,
    };
