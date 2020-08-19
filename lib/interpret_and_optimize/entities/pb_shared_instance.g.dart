// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_shared_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBSharedInstanceIntermediateNode _$PBSharedInstanceIntermediateNodeFromJson(
    Map<String, dynamic> json) {
  return PBSharedInstanceIntermediateNode(
    SymbolInstance.fromJson(json['originalRef'] as Map<String, dynamic>),
    json['SYMBOL_ID'] as String,
    topLeftCorner:
        Point.fromJson(json['topLeftCorner'] as Map<String, dynamic>),
    bottomRightCorner:
        Point.fromJson(json['bottomRightCorner'] as Map<String, dynamic>),
  )
    ..subsemantic = json['subsemantic'] as String
    ..child = json['child']
    ..color = json['color'] as String
    ..size = json['size'] as Map<String, dynamic>
    ..borderInfo = json['borderInfo'] as Map<String, dynamic>
    ..alignment = json['alignment'] as Map<String, dynamic>
    ..UUID = json['UUID'] as String
    ..functionCallName = json['functionCallName'] as String
    ..foundMaster = json['foundMaster'] as bool
    ..widgetType = json['widgetType'] as String
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
      'UUID': instance.UUID,
      'SYMBOL_ID': instance.SYMBOL_ID,
      'functionCallName': instance.functionCallName,
      'foundMaster': instance.foundMaster,
      'originalRef': instance.originalRef,
      'widgetType': instance.widgetType,
      'overrideValues': instance.overrideValues,
    };
