// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBConfiguration _$PBConfigurationFromJson(Map<String, dynamic> json) {
  return PBConfiguration(
    json['scaling'] as bool ?? true,
    json['breakpoints'] as Map<String, dynamic>,
    figmaOauthToken: json['oauth'] as String,
    figmaKey: json['figKey'] as String,
    figmaProjectID: json['fig'] as String,
    projectName: json['project-name'] as String ?? 'foo',
    outputPath: json['out'] as String,
    pbdlPath: json['pbdl-in'] as String,
    exportPBDL: json['export-pbdl'] as bool ?? false,
    folderArchitecture: json['folderArchitecture'] as String ?? 'domain',
    componentIsolation: json['componentIsolation'] as String ?? 'None',
    level: json['level'] as String ?? 'screen',
  );
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
      'folderArchitecture': instance.folderArchitecture,
      'scaling': instance.scaling,
      'breakpoints': instance.breakpoints,
      'componentIsolation': instance.componentIsolation,
      'level': instance.level,
    };
