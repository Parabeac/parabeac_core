// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_shared_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBSharedInstanceIntermediateNode _$PBSharedInstanceIntermediateNodeFromJson(
    Map<String, dynamic> json) {
  return PBSharedInstanceIntermediateNode(
    SYMBOL_ID: json['symbolID'] as String,
    sharedParamValues: (json['overrideValues'] as List)
        ?.map((e) => e == null
            ? null
            : PBSharedParameterValue.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    UUID: json['UUID'] as String,
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNodeUUID'] as String),
    size: PBIntermediateNode.sizeFromJson(
        json['boundaryRectangle'] as Map<String, dynamic>),
    name: json['name'] as String,
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

Map<String, dynamic> _$PBSharedInstanceIntermediateNodeToJson(
        PBSharedInstanceIntermediateNode instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'children': instance.children?.map((e) => e?.toJson())?.toList(),
      'child': instance.child?.toJson(),
      'style': instance.auxiliaryData?.toJson(),
      'name': instance.name,
      'symbolID': instance.SYMBOL_ID,
      'overrideValues':
          instance.sharedParamValues?.map((e) => e?.toJson())?.toList(),
      'prototypeNodeUUID': instance.prototypeNode?.toJson(),
      'type': instance.type,
      'UUID': instance.UUID,
      'boundaryRectangle': instance.size,
    };

PBSharedParameterValue _$PBSharedParameterValueFromJson(
    Map<String, dynamic> json) {
  return PBSharedParameterValue(
    json['type'] as String,
    json['value'],
    json['UUID'] as String,
    json['name'] as String,
  );
}

Map<String, dynamic> _$PBSharedParameterValueToJson(
        PBSharedParameterValue instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.initialValue,
      'UUID': instance.UUID,
      'name': instance.overrideName,
    };
