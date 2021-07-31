// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_intermediate_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$PBIntermediateNodeToJson(PBIntermediateNode instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'UUID': instance.UUID,
      'children': instance.children?.map((e) => e?.toJson())?.toList(),
      'child': instance.child?.toJson(),
      'topLeftCorner': instance.topLeftCorner?.toJson(),
      'bottomRightCorner': instance.bottomRightCorner?.toJson(),
      'size': instance.size,
      'style': instance.auxiliaryData?.toJson(),
      'name': instance.name,
    };
