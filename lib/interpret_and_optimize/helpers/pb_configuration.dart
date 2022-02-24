import 'package:path/path.dart' as p;

import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/bloc_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/provider_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/riverpod_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/stateful_generation_configuration.dart';
part 'pb_configuration.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: true)
class PBConfiguration {
  static final Map<String, GenerationConfiguration> availableGenConfigs = {
    'provider': ProviderGenerationConfiguration(),
    'bloc': BLoCGenerationConfiguration(),
    'riverpod': RiverpodGenerationConfiguration(),
    'none': StatefulGenerationConfiguration(),
  };

  ///The [GenerationConfiguration] that is going to be use in the generation of the code
  ///
  ///This is going to be defaulted to [GenerationConfiguration] if nothing else is specified.
  GenerationConfiguration generationConfiguration;

  String platform;

  String projectName;

  String outputDirPath;

  // @JsonKey(defaultValue: 'Material')
  final String widgetStyle = 'Material';

  @JsonKey(defaultValue: true)
  final bool scaling;

  // @JsonKey(defaultValue: 'Stateless')
  final String widgetType = 'Stateless';

  // @JsonKey(defaultValue: 'Expanded')
  final String widgetSpacing = 'Expanded';

  // @JsonKey(defaultValue: 'None', name: 'state-management')
  final String stateManagement = 'none';

  // @JsonKey(defaultValue: ['column', 'row', 'stack'])
  final List<String> layoutPrecedence = ['column', 'row', 'stack'];

  @JsonKey(name: 'breakpoints')
  final Map breakpoints;

  @JsonKey(defaultValue: false)
  final bool enablePrototyping;

  @JsonKey(defaultValue: 'None')
  final String componentIsolation;

  PBConfiguration(
    // this.widgetStyle,
    // this.widgetType,
    // this.widgetSpacing,
    // this.stateManagement,
    // this.layoutPrecedence,
    this.breakpoints,
    this.scaling,
    this.enablePrototyping,
    this.componentIsolation,
  );

  /// Converting the [json] into a [PBConfiguration] object.
  ///
  /// The [generationConfiguration] is going to be set manually, by grabbing the
  /// value that is comming from [stateManagement].
  factory PBConfiguration.fromJson(Map<String, dynamic> json) {
    var configuration = _$PBConfigurationFromJson(json);
    // configuration.generationConfiguration =
    //     availableGenConfigs[configuration.stateManagement.toLowerCase()];
    configuration.generationConfiguration ??= StatefulGenerationConfiguration();
    return configuration;
  }

  /// Generating the default configuration if there is no json file found for [PBConfiguration]
  /// to take in.
  factory PBConfiguration.genericConfiguration() {
    var defaultConfigs = <String, dynamic>{
      // 'widgetStyle': 'Material',
      // 'widgetType': 'Stateless',
      // 'widgetSpacing': 'Expanded',
      // 'layoutPrecedence': ['columns', 'rows', 'stack'],
      // 'state-management': 'None'
    };
    return PBConfiguration.fromJson(defaultConfigs);
  }
  Map<String, dynamic> toJson() => _$PBConfigurationToJson(this);
}
