// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_shared_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBSharedInstanceIntermediateNode _$PBSharedInstanceIntermediateNodeFromJson(
    Map<String, dynamic> json) {
  return PBSharedInstanceIntermediateNode(
    json['UUID'] as String,
    Rectangle3D.fromJson(json['boundaryRectangle'] as Map<String, dynamic>),
    SYMBOL_ID: json['symbolID'] as String,
    sharedParamValues: (json['overrideValues'] as List)
        ?.map((e) => e == null
            ? null
            : PBInstanceOverride.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNodeUUID'] as String),
    name: json['name'] as String,
  )
    ..subsemantic = json['subsemantic'] as String
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

Map<String, dynamic> _$PBSharedInstanceIntermediateNodeToJson(
        PBSharedInstanceIntermediateNode instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'UUID': instance.UUID,
      'constraints': instance.constraints?.toJson(),
      'boundaryRectangle': Rectangle3D.toJson(instance.frame),
      'style': instance.auxiliaryData?.toJson(),
      'name': instance.name,
      'symbolID': instance.SYMBOL_ID,
      'overrideValues':
          instance.sharedParamValues?.map((e) => e?.toJson())?.toList(),
      'prototypeNodeUUID': instance.prototypeNode?.toJson(),
      'type': instance.type,
    };

PBInstanceOverride _$PBInstanceOverrideFromJson(Map<String, dynamic> json) {
  return PBInstanceOverride(
    json['type'] as String,
    json['value'],
    json['UUID'] as String,
    json['name'] as String,
  );
}

Map<String, dynamic> _$PBInstanceOverrideToJson(PBInstanceOverride instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.initialValue,
      'UUID': instance.UUID,
      'name': instance.overrideName,
    };
