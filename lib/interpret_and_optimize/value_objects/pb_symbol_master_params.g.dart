// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_symbol_master_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBSymbolMasterParameter _$PBSymbolMasterParameterFromJson(
    Map<String, dynamic> json) {
  return PBSymbolMasterParameter(
    PBSymbolMasterParameter._typeFromJson(json['type']),
    json['parameterID'] as String,
    json['canOverride'] as bool,
    json['propertyName'] as String,
    json['parameterDefinition'],
    (json['topLeftX'] as num).toDouble(),
    (json['topLeftY'] as num).toDouble(),
    (json['bottomRightX'] as num).toDouble(),
    (json['bottomRightY'] as num).toDouble(),
  )
    ..subsemantic = json['subsemantic'] as String
    ..widgetType = json['widgetType'] as String
    ..child = json['child']
    ..topLeftCorner =
        Point.fromJson(json['topLeftCorner'] as Map<String, dynamic>)
    ..bottomRightCorner =
        Point.fromJson(json['bottomRightCorner'] as Map<String, dynamic>)
    ..size = json['size'] as Map<String, dynamic>
    ..borderInfo = json['borderInfo'] as Map<String, dynamic>
    ..alignment = json['alignment'] as Map<String, dynamic>
    ..name = json['name'] as String
    ..color = json['color'] as String;
}

Map<String, dynamic> _$PBSymbolMasterParameterToJson(
        PBSymbolMasterParameter instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'widgetType': instance.widgetType,
      'child': instance.child,
      'topLeftCorner': instance.topLeftCorner,
      'bottomRightCorner': instance.bottomRightCorner,
      'size': instance.size,
      'borderInfo': instance.borderInfo,
      'alignment': instance.alignment,
      'name': instance.name,
      'color': instance.color,
      'type': PBSymbolMasterParameter._typeToJson(instance.type),
      'parameterID': instance.parameterID,
      'canOverride': instance.canOverride,
      'propertyName': instance.propertyName,
      'parameterDefinition': instance.parameterDefinition,
      'topLeftX': instance.topLeftX,
      'topLeftY': instance.topLeftY,
      'bottomRightX': instance.bottomRightX,
      'bottomRightY': instance.bottomRightY,
    };
