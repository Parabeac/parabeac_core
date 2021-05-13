// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBConfiguration _$PBConfigurationFromJson(Map<String, dynamic> json) {
  return PBConfiguration(
    json['widgetStyle'] as String ?? 'Material',
    json['widgetType'] as String ?? 'Stateless',
    json['widgetSpacing'] as String ?? 'Expandeds',
    json['stateManagement'] as String ?? 'None',
    (json['layoutPrecedence'] as List)?.map((e) => e as String)?.toList() ??
        ['column', 'row', 'stacl'],
  )..configurations = json['configurations'] as Map<String, dynamic>;
}

Map<String, dynamic> _$PBConfigurationToJson(PBConfiguration instance) =>
    <String, dynamic>{
      'widgetStyle': instance.widgetStyle,
      'widgetType': instance.widgetType,
      'widgetSpacing': instance.widgetSpacing,
      'stateManagement': instance.stateManagement,
      'layoutPrecedence': instance.layoutPrecedence,
      'configurations': instance.configurations,
    };
