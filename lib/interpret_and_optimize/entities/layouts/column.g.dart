// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'column.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBIntermediateColumnLayout _$PBIntermediateColumnLayoutFromJson(
    Map<String, dynamic> json) {
  return PBIntermediateColumnLayout(
    json['name'] as String,
    UUID: json['UUID'] as String,
  )
    ..subsemantic = json['subsemantic'] as String
    ..child = json['child']
    ..color = json['color'] as String
    ..size = json['size'] as Map<String, dynamic>
    ..borderInfo = json['borderInfo'] as Map<String, dynamic>
    ..alignment = json['alignment'] as Map<String, dynamic>
    ..name = json['name'] as String
    ..prototypeNode = json['prototypeNode'] == null
        ? null
        : PrototypeNode.fromJson(json['prototypeNode'] as Map<String, dynamic>)
    ..alignment = json['alignment'] as Map<String, dynamic>;
}

Map<String, dynamic> _$PBIntermediateColumnLayoutToJson(
        PBIntermediateColumnLayout instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'child': instance.child,
      'color': instance.color,
      'size': instance.size,
      'borderInfo': instance.borderInfo,
      'name': instance.name,
      'prototypeNode': instance.prototypeNode,
      'UUID': instance.UUID,
      'alignment': instance.alignment,
    };
