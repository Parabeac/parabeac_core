// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_shared_master_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBSharedMasterNode _$PBSharedMasterNodeFromJson(Map<String, dynamic> json) {
  return PBSharedMasterNode(
    SYMBOL_ID: json['symbolID'] as String,
    name: json['name'] as String,
    topLeftCorner:
        Point.topLeftFromJson(json['topLeftCorner'] as Map<String, dynamic>),
    bottomRightCorner: Point.bottomRightFromJson(
        json['bottomRightCorner'] as Map<String, dynamic>),
    UUID: json['UUID'] as String,
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNode'] as Map<String, dynamic>),
    type: json['type'] as String,
    size: PBIntermediateNode.sizeFromJson(json['size'] as Map<String, dynamic>),
  )
    ..subsemantic = json['subsemantic'] as String
    ..child = json['child'] == null
        ? null
        : PBIntermediateNode.fromJson(json['child'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PBSharedMasterNodeToJson(PBSharedMasterNode instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'child': instance.child?.toJson(),
      'name': instance.name,
      'prototypeNode': instance.prototypeNode?.toJson(),
      'symbolID': instance.SYMBOL_ID,
      'type': instance.type,
      'topLeftCorner': instance.topLeftCorner?.toJson(),
      'bottomRightCorner': instance.bottomRightCorner?.toJson(),
      'UUID': instance.UUID,
      'size': instance.size,
    };

PBSharedParameterProp _$PBSharedParameterPropFromJson(
    Map<String, dynamic> json) {
  return PBSharedParameterProp(
    json['type'] as String,
    json['value'] == null
        ? null
        : PBIntermediateNode.fromJson(json['value'] as Map<String, dynamic>),
    json['propertyName'] as String,
    json['UUID'] as String,
    json['initialValue'],
  );
}

Map<String, dynamic> _$PBSharedParameterPropToJson(
        PBSharedParameterProp instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
      'propertyName': instance.propertyName,
      'UUID': instance.UUID,
      'initialValue': instance.initialValue,
    };
