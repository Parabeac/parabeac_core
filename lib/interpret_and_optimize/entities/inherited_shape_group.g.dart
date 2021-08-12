// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_shape_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedShapeGroup _$InheritedShapeGroupFromJson(Map<String, dynamic> json) {
  return InheritedShapeGroup(
    json['UUID'] as String,
    DeserializedRectangle.fromJson(json['frame'] as Map<String, dynamic>),
    name: json['name'] as String,
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNodeUUID'] as String),
    size: PBIntermediateNode.sizeFromJson(
        json['boundaryRectangle'] as Map<String, dynamic>),
  )
    ..parent = json['parent'] == null
        ? null
        : PBIntermediateNode.fromJson(json['parent'] as Map<String, dynamic>)
    ..treeLevel = json['treeLevel'] as int
    ..subsemantic = json['subsemantic'] as String
    ..child = json['child'] == null
        ? null
        : PBIntermediateNode.fromJson(json['child'] as Map<String, dynamic>)
    ..topLeftCorner = PBPointLegacyMethod.topLeftFromJson(
        json['topLeftCorner'] as Map<String, dynamic>)
    ..bottomRightCorner = PBPointLegacyMethod.bottomRightFromJson(
        json['bottomRightCorner'] as Map<String, dynamic>)
    ..auxiliaryData = json['style'] == null
        ? null
        : IntermediateAuxiliaryData.fromJson(
            json['style'] as Map<String, dynamic>)
    ..type = json['type'] as String;
}

Map<String, dynamic> _$InheritedShapeGroupToJson(
        InheritedShapeGroup instance) =>
    <String, dynamic>{
      'parent': instance.parent,
      'treeLevel': instance.treeLevel,
      'subsemantic': instance.subsemantic,
      'UUID': instance.UUID,
      'child': instance.child,
      'topLeftCorner': PBPointLegacyMethod.toJson(instance.topLeftCorner),
      'bottomRightCorner':
          PBPointLegacyMethod.toJson(instance.bottomRightCorner),
      'frame': DeserializedRectangle.toJson(instance.frame),
      'style': instance.auxiliaryData,
      'name': instance.name,
      'prototypeNodeUUID': instance.prototypeNode,
      'type': instance.type,
      'boundaryRectangle': instance.size,
    };
