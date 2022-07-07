import 'package:path/path.dart' as p;

import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/bloc_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/provider_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/riverpod_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/stateful_generation_configuration.dart';
part 'pb_configuration.g.dart';

/// Class that represents Parabeac project configuration
@JsonSerializable(nullable: true, ignoreUnannotated: true)
class PBConfiguration {
  static final Map<String, GenerationConfiguration> availableGenConfigs = {
    'provider': ProviderGenerationConfiguration(),
    'bloc': BLoCGenerationConfiguration(),
    'riverpod': RiverpodGenerationConfiguration(),
    'none': StatefulGenerationConfiguration(),
  };

  /// TODO: Abstract this when we have a Figma Command and change command-line names
  /// OAuth Token to call Figma API
  @JsonKey(name: 'oauth')
  String figmaOauthToken;

  /// API key needed to do API calls
  @JsonKey(name: 'figKey')
  String figmaKey;

  @JsonKey(name: 'fig')
  String figmaProjectID;

  /// Name to be given to the exported project
  @JsonKey(name: 'project-name')
  String projectName;

  /// Where the conversion result will be output.
  @JsonKey(name: 'out')
  String outputPath;

  /// Path to PBDL file
  @JsonKey(name: 'pbdl-in')
  String pbdlPath;

  /// Whether parabeac_core should export a PBDL file
  @JsonKey(name: 'export-pbdl')
  bool exportPBDL;

  //TODO: Invert this logic?
  @JsonKey(name: 'exclude-styles')
  bool exportStyles;

  ///The [GenerationConfiguration] that is going to be use in the generation of the code
  ///
  ///This is going to be defaulted to [GenerationConfiguration] if nothing else is specified.
  GenerationConfiguration generationConfiguration;

  String platform;

  final String widgetStyle = 'Material';

  /// The type of folder architecture that Parabeac-Core should follow
  /// It will be domain, as default
  @JsonKey(defaultValue: 'domain')
  final String folderArchitecture;

  @JsonKey(defaultValue: true)
  final bool scaling;

  @JsonKey(name: 'breakpoints')
  final Map breakpoints;

  @JsonKey(defaultValue: 'None')
  final String componentIsolation;

  PBConfiguration(
    this.folderArchitecture,
    this.scaling,
    this.breakpoints,
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
