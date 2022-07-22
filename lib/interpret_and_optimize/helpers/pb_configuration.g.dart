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
    integrationLevel: _$enumDecodeNullable(
            _$IntegrationlevelEnumMap, json['integrationLevel']) ??
        IntegrationLevel.screen,
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
      'integrationLevel': _$IntegrationlevelEnumMap[instance.integrationLevel],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$IntegrationlevelEnumMap = {
  IntegrationLevel.theming: 'theming',
  IntegrationLevel.component: 'component',
  IntegrationLevel.screen: 'screen',
};
