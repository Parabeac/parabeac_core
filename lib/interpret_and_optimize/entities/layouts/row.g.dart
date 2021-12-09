// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBIntermediateRowLayout _$PBIntermediateRowLayoutFromJson(
    Map<String, dynamic> json) {
  return PBIntermediateRowLayout(
    name: json['name'] as String,
  )
    ..subsemantic = json['subsemantic'] as String
    ..constraints = json['constraints'] == null
        ? null
        : PBIntermediateConstraints.fromJson(
            json['constraints'] as Map<String, dynamic>)
    ..frame =
        Rectangle3D.fromJson(json['boundaryRectangle'] as Map<String, dynamic>)
    ..auxiliaryData = json['style'] == null
        ? null
        : IntermediateAuxiliaryData.fromJson(
            json['style'] as Map<String, dynamic>)
    ..alignment = json['alignment'] as Map<String, dynamic>
    ..prototypeNode = json['prototypeNode'] == null
        ? null
        : PrototypeNode.fromJson(json['prototypeNode'] as Map<String, dynamic>)
    ..layoutProperties = json['autoLayoutOptions'] == null
        ? null
        : LayoutProperties.fromJson(
            json['autoLayoutOptions'] as Map<String, dynamic>)
    ..type = json['type'] as String;
}

Map<String, dynamic> _$PBIntermediateRowLayoutToJson(
        PBIntermediateRowLayout instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'constraints': instance.constraints,
      'boundaryRectangle': Rectangle3D.toJson(instance.frame),
      'style': instance.auxiliaryData,
      'name': instance.name,
      'alignment': instance.alignment,
      'prototypeNode': instance.prototypeNode,
      'autoLayoutOptions': instance.layoutProperties,
      'type': instance.type,
    };
