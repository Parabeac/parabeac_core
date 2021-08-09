// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_shared_master_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBSharedMasterNode _$PBSharedMasterNodeFromJson(Map<String, dynamic> json) {
  return PBSharedMasterNode(
    SYMBOL_ID: json['symbolID'] as String,
    name: json['name'] as String,
    overridableProperties: (json['overrideProperties'] as List)
        ?.map((e) => e == null
            ? null
            : PBSharedParameterProp.fromJson(e as Map<String, dynamic>))
        ?.toList(),
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

Map<String, dynamic> _$PBSharedMasterNodeToJson(PBSharedMasterNode instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'child': instance.child?.toJson(),
      'style': instance.auxiliaryData?.toJson(),
      'name': instance.name,
      'prototypeNodeUUID': instance.prototypeNode?.toJson(),
      'symbolID': instance.SYMBOL_ID,
      'type': instance.type,
      'UUID': instance.UUID,
      'boundaryRectangle': instance.size,
      'overrideProperties':
          instance.overridableProperties?.map((e) => e?.toJson())?.toList(),
    };

PBSharedParameterProp _$PBSharedParameterPropFromJson(
    Map<String, dynamic> json) {
  return PBSharedParameterProp(
    json['type'] as String,
    json['value'] == null
        ? null
        : PBIntermediateNode.fromJson(json['value'] as Map<String, dynamic>),
    PBSharedParameterProp._propertyNameFromJson(json['name'] as String),
    json['UUID'] as String,
  );
}

Map<String, dynamic> _$PBSharedParameterPropToJson(
        PBSharedParameterProp instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
      'name': instance.propertyName,
      'UUID': instance.UUID,
    };
