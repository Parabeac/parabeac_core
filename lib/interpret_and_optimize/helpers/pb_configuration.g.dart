// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBConfiguration _$PBConfigurationFromJson(Map<String, dynamic> json) {
  return PBConfiguration(
    json['breakpoints'] as Map<String, dynamic>,
    json['scaling'] as bool ?? true,
    json['enablePrototyping'] as bool ?? false,
    json['componentIsolation'] as String ?? 'None',
    json['folderArchitecture'] as String ?? 'domain',
  );
}

Map<String, dynamic> _$PBConfigurationToJson(PBConfiguration instance) =>
    <String, dynamic>{
      'scaling': instance.scaling,
      'breakpoints': instance.breakpoints,
      'enablePrototyping': instance.enablePrototyping,
      'componentIsolation': instance.componentIsolation,
      'folderArchitecture': instance.folderArchitecture,
    };
