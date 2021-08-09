// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temp_group_layout_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TempGroupLayoutNode _$TempGroupLayoutNodeFromJson(Map<String, dynamic> json) {
  return TempGroupLayoutNode(
    name: json['name'] as String,
    UUID: json['UUID'] as String,
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNodeUUID'] as String),
    size: PBIntermediateNode.sizeFromJson(
        json['boundaryRectangle'] as Map<String, dynamic>),
  )
    ..subsemantic = json['subsemantic'] as String
    ..child = json['child'] == null
        ? null
        : PBIntermediateNode.fromJson(json['child'] as Map<String, dynamic>)
    ..auxiliaryData = json['style'] == null
        ? null
        : IntermediateAuxiliaryData.fromJson(
            json['style'] as Map<String, dynamic>)
    ..type = json['type'] as String;
}

Map<String, dynamic> _$TempGroupLayoutNodeToJson(
        TempGroupLayoutNode instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'child': instance.child?.toJson(),
      'style': instance.auxiliaryData?.toJson(),
      'name': instance.name,
      'prototypeNodeUUID': instance.prototypeNode?.toJson(),
      'type': instance.type,
      'UUID': instance.UUID,
      'boundaryRectangle': instance.size,
    };
