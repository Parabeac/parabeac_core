// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBConfiguration _$PBConfigurationFromJson(Map<String, dynamic> json) {
  return PBConfiguration(
    json['folderArchitecture'] as String ?? 'domain',
    json['scaling'] as bool ?? true,
    json['breakpoints'] as Map<String, dynamic>,
    json['componentIsolation'] as String ?? 'None',
  )
    ..figmaOauthToken = json['oauth'] as String
    ..figmaKey = json['figKey'] as String
    ..figmaProjectID = json['fig'] as String
    ..projectName = json['project-name'] as String
    ..outputPath = json['out'] as String
    ..pbdlPath = json['pbdl-in'] as String
    ..exportPBDL = json['export-pbdl'] as bool
    ..exportStyles = json['exclude-styles'] as bool;
}

Map<String, dynamic> _$PBConfigurationToJson(PBConfiguration instance) =>
    <String, dynamic>{
      'oauth': instance.figmaOauthToken,
      'figKey': instance.figmaKey,
      'fig': instance.figmaProjectID,
      'project-name': instance.projectName,
      'out': instance.outputPath,
      'pbdl-in': instance.pbdlPath,
      'export-pbdl': instance.exportPBDL,
      'exclude-styles': instance.exportStyles,
      'folderArchitecture': instance.folderArchitecture,
      'scaling': instance.scaling,
      'breakpoints': instance.breakpoints,
      'componentIsolation': instance.componentIsolation,
    };
