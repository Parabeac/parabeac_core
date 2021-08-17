// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_shape_path.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InheritedShapePath _$InheritedShapePathFromJson(Map<String, dynamic> json) {
  return InheritedShapePath(
    json['UUID'] as String,
    DeserializedRectangle.fromJson(
        json['boundaryRectangle'] as Map<String, dynamic>),
    name: json['name'] as String,
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNodeUUID'] as String),
  )
    ..constraints = json['constraints'] == null
        ? null
        : PBIntermediateConstraints.fromJson(
            json['constraints'] as Map<String, dynamic>)
    ..auxiliaryData = json['style'] == null
        ? null
        : IntermediateAuxiliaryData.fromJson(
            json['style'] as Map<String, dynamic>)
    ..type = json['type'] as String;
}

Map<String, dynamic> _$InheritedShapePathToJson(InheritedShapePath instance) =>
    <String, dynamic>{
      'UUID': instance.UUID,
      'constraints': instance.constraints,
      'boundaryRectangle': DeserializedRectangle.toJson(instance.frame),
      'style': instance.auxiliaryData,
      'name': instance.name,
      'prototypeNodeUUID': instance.prototypeNode,
      'type': instance.type,
    };
