// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBIntermediateRowLayout _$PBIntermediateRowLayoutFromJson(
    Map<String, dynamic> json) {
  return PBIntermediateRowLayout(
    json['UUID'] as String,
  )
    ..subsemantic = json['subsemantic'] as String
    ..child = json['child']
    ..color = json['color'] as String
    ..size = json['size'] as Map<String, dynamic>
    ..borderInfo = json['borderInfo'] as Map<String, dynamic>
    ..alignment = json['alignment'] as Map<String, dynamic>
    ..widgetType = json['widgetType'] as String;
}

Map<String, dynamic> _$PBIntermediateRowLayoutToJson(
        PBIntermediateRowLayout instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'child': instance.child,
      'color': instance.color,
      'size': instance.size,
      'borderInfo': instance.borderInfo,
      'UUID': instance.UUID,
      'alignment': instance.alignment,
      'widgetType': instance.widgetType,
    };
