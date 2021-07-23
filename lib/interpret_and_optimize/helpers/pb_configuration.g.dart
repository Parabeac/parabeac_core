// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBConfiguration _$PBConfigurationFromJson(Map<String, dynamic> json) {
  return PBConfiguration(
    json['widgetStyle'] as String ?? 'Material',
    json['widgetType'] as String ?? 'Stateless',
    json['widgetSpacing'] as String ?? 'Expanded',
    json['state-management'] as String ?? 'None',
    (json['layoutPrecedence'] as List)?.map((e) => e as String)?.toList() ??
        ['column', 'row', 'stack'],
    json['breakpoints'] as Map<String, dynamic>,
    json['scaling'] as bool ?? true,
  );
}

Map<String, dynamic> _$PBConfigurationToJson(PBConfiguration instance) =>
    <String, dynamic>{
      'widgetStyle': instance.widgetStyle,
      'scaling': instance.scaling,
      'widgetType': instance.widgetType,
      'widgetSpacing': instance.widgetSpacing,
      'state-management': instance.stateManagement,
      'layoutPrecedence': instance.layoutPrecedence,
      'breakpoints': instance.breakpoints,
    };
