// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_shared_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBSharedInstanceIntermediateNode _$PBSharedInstanceIntermediateNodeFromJson(
    Map<String, dynamic> json) {
  return PBSharedInstanceIntermediateNode(
    json['UUID'] as String,
    DeserializedRectangle.fromJson(json['frame'] as Map<String, dynamic>),
    SYMBOL_ID: json['symbolID'] as String,
    sharedParamValues: (json['overrideValues'] as List)
        ?.map((e) => e == null
            ? null
            : PBSharedParameterValue.fromJson(e as Map<String, dynamic>))
        ?.toList(),
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

Map<String, dynamic> _$PBSharedInstanceIntermediateNodeToJson(
        PBSharedInstanceIntermediateNode instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'UUID': instance.UUID,
      'children': instance.children?.map((e) => e?.toJson())?.toList(),
      'child': instance.child?.toJson(),
      'topLeftCorner': PBPointLegacyMethod.toJson(instance.topLeftCorner),
      'bottomRightCorner':
          PBPointLegacyMethod.toJson(instance.bottomRightCorner),
      'frame': DeserializedRectangle.toJson(instance.frame),
      'style': instance.auxiliaryData?.toJson(),
      'name': instance.name,
      'symbolID': instance.SYMBOL_ID,
      'overrideValues':
          instance.sharedParamValues?.map((e) => e?.toJson())?.toList(),
      'prototypeNodeUUID': instance.prototypeNode?.toJson(),
      'type': instance.type,
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
