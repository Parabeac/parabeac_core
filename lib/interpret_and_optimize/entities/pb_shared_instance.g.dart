// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_shared_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBSharedInstanceIntermediateNode _$PBSharedInstanceIntermediateNodeFromJson(
    Map<String, dynamic> json) {
  return PBSharedInstanceIntermediateNode(
    json['originalRef'],
    json['SYMBOL_ID'] as String,
    topLeftCorner: json['topLeftCorner'] == null
        ? null
        : Point.fromJson(json['topLeftCorner'] as Map<String, dynamic>),
    bottomRightCorner: json['bottomRightCorner'] == null
        ? null
        : Point.fromJson(json['bottomRightCorner'] as Map<String, dynamic>),
  )
    ..subsemantic = json['subsemantic'] as String
    ..child = json['child']
    ..color = json['color'] as String
    ..size = json['size'] as Map<String, dynamic>
    ..borderInfo = json['borderInfo'] as Map<String, dynamic>
    ..alignment = json['alignment'] as Map<String, dynamic>
    ..name = json['name'] as String
    ..UUID = json['UUID'] as String
    ..functionCallName = json['functionCallName'] as String
    ..foundMaster = json['foundMaster'] as bool
    ..overrideValues = json['overrideValues'] as List;
}

Map<String, dynamic> _$PBSharedInstanceIntermediateNodeToJson(
        PBSharedInstanceIntermediateNode instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'child': instance.child,
      'topLeftCorner': instance.topLeftCorner,
      'bottomRightCorner': instance.bottomRightCorner,
      'color': instance.color,
      'size': instance.size,
      'borderInfo': instance.borderInfo,
      'alignment': instance.alignment,
      'name': instance.name,
      'UUID': instance.UUID,
      'SYMBOL_ID': instance.SYMBOL_ID,
      'functionCallName': instance.functionCallName,
      'foundMaster': instance.foundMaster,
      'originalRef': instance.originalRef,
      'overrideValues': instance.overrideValues,
    };
