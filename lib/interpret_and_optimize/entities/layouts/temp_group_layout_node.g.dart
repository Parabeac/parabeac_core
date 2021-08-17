// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temp_group_layout_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TempGroupLayoutNode _$TempGroupLayoutNodeFromJson(Map<String, dynamic> json) {
  return TempGroupLayoutNode(
    json['UUID'] as String,
    DeserializedRectangle.fromJson(
        json['boundaryRectangle'] as Map<String, dynamic>),
    name: json['name'] as String,
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNodeUUID'] as String),
    constraints: json['constraints'] == null
        ? null
        : PBIntermediateConstraints.fromJson(
            json['constraints'] as Map<String, dynamic>),
  )
    ..auxiliaryData = json['style'] == null
        ? null
        : IntermediateAuxiliaryData.fromJson(
            json['style'] as Map<String, dynamic>)
    ..type = json['type'] as String;
}

Map<String, dynamic> _$TempGroupLayoutNodeToJson(
        TempGroupLayoutNode instance) =>
    <String, dynamic>{
      'UUID': instance.UUID,
      'constraints': instance.constraints?.toJson(),
      'boundaryRectangle': DeserializedRectangle.toJson(instance.frame),
      'style': instance.auxiliaryData?.toJson(),
      'name': instance.name,
      'prototypeNodeUUID': instance.prototypeNode?.toJson(),
      'type': instance.type,
    };
