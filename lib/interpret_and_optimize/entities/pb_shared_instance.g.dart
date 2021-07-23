// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_shared_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBSharedInstanceIntermediateNode _$PBSharedInstanceIntermediateNodeFromJson(
    Map<String, dynamic> json) {
  return PBSharedInstanceIntermediateNode(
    SYMBOL_ID: json['SYMBOL_ID'] as String,
    sharedParamValues: (json['overrideValues'] as List)
        ?.map((e) => e == null
            ? null
            : PBSharedParameterValue.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    topLeftCorner:
        Point.topLeftFromJson(json['topLeftCorner'] as Map<String, dynamic>),
    bottomRightCorner: Point.bottomRightFromJson(
        json['bottomRightCorner'] as Map<String, dynamic>),
    UUID: json['UUID'] as String,
    prototypeNode: PrototypeNode.prototypeNodeFromJson(
        json['prototypeNode'] as Map<String, dynamic>),
    size: PBIntermediateNode.sizeFromJson(json['size'] as Map<String, dynamic>),
    type: json['type'] as String,
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
        : PBIntermediateNode.fromJson(json['child'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PBSharedInstanceIntermediateNodeToJson(
        PBSharedInstanceIntermediateNode instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'children': instance.children?.map((e) => e?.toJson())?.toList(),
      'child': instance.child?.toJson(),
      'name': instance.name,
      'SYMBOL_ID': instance.SYMBOL_ID,
      'overrideValues':
          instance.sharedParamValues?.map((e) => e?.toJson())?.toList(),
      'prototypeNode': instance.prototypeNode?.toJson(),
      'type': instance.type,
      'topLeftCorner': instance.topLeftCorner?.toJson(),
      'bottomRightCorner': instance.bottomRightCorner?.toJson(),
      'UUID': instance.UUID,
      'size': instance.size,
    };

PBSharedParameterValue _$PBSharedParameterValueFromJson(
    Map<String, dynamic> json) {
  return PBSharedParameterValue(
    json['type'] as String,
    json['value'],
    json['UUID'] as String,
    json['overrideName'] as String,
  );
}

Map<String, dynamic> _$PBSharedParameterValueToJson(
        PBSharedParameterValue instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
      'UUID': instance.UUID,
      'overrideName': instance.overrideName,
    };
