import 'dart:io';

import 'package:args/args.dart';

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
  @JsonKey(name: 'project-name', defaultValue: 'foo')
  String projectName;

  /// Where the conversion result will be output.
  @JsonKey(name: 'out')
  String outputPath;

  /// Path to PBDL file
  @JsonKey(name: 'pbdl-in')
  String pbdlPath;

  /// Whether parabeac_core should export a PBDL file
  @JsonKey(name: 'export-pbdl', defaultValue: false)
  bool exportPBDL;

  ///The [GenerationConfiguration] that is going to be use in the generation of the code
  ///
  ///This is going to be defaulted to [GenerationConfiguration] if nothing else is specified.
  GenerationConfiguration generationConfiguration;

  final String widgetStyle = 'Material';

  /// The type of folder architecture that Parabeac-Core should follow
  /// It will be domain, as default
  @JsonKey(defaultValue: 'domain')
  String folderArchitecture;

  @JsonKey(defaultValue: true)
  final bool scaling;

  @JsonKey(name: 'breakpoints')
  final Map breakpoints;

  @JsonKey(defaultValue: 'None')
  String componentIsolation;

  /// The level of integration of this project
  @JsonKey(defaultValue: IntegrationLevel.screens, name: 'level')
  IntegrationLevel integrationLevel;

  PBConfiguration(
    this.scaling,
    this.breakpoints, {
    this.figmaOauthToken,
    this.figmaKey,
    this.figmaProjectID,
    this.projectName,
    this.outputPath,
    this.pbdlPath,
    this.exportPBDL,
    this.folderArchitecture,
    this.componentIsolation,
    this.integrationLevel,
  });

  /// Converting the [json] into a [PBConfiguration] object.
  ///
  /// The [generationConfiguration] is going to be set manually, by grabbing the
  /// value that is comming from [stateManagement].
  factory PBConfiguration.fromJson(Map<String, dynamic> json) {
    var configuration = _$PBConfigurationFromJson(json);
    configuration.generationConfiguration ??= StatefulGenerationConfiguration();
    return configuration;
  }

  /// Merges [arguments] with [this], giving priority to [arguments].
  void mergeWithArgs(ArgResults arguments) {
    outputPath = arguments['out'] ?? outputPath;
    projectName = arguments['project-name'] ?? projectName;
    figmaProjectID = arguments['fig'] ?? figmaProjectID;
    figmaKey = arguments['figKey'] ?? figmaKey;
    pbdlPath = arguments['pbdl-in'] ?? pbdlPath;
    figmaOauthToken = arguments['oauth'] ?? figmaOauthToken;
    folderArchitecture = arguments['folderArchitecture'] ?? folderArchitecture;
    componentIsolation = arguments['componentIsolation'] ?? componentIsolation;

    if (arguments['project-type'] != null) {
      integrationLevel =
          _$enumDecode(_$IntegrationLevelEnumMap, arguments['project-type']);
    }

    /// export-pbdl is non-negatable, therefore if it's not set, we go with the config's value.
    exportPBDL = arguments['export-pbdl'] ? true : exportPBDL;
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

  void validate() {
    if (_hasTooFewArgs()) {
      throw Exception(
          'Missing required arguments: Ensure you provided a valid Figma Key and Project ID.');
    } else if (_hasTooManyArgs()) {
      throw Exception(
          'Too many arguments: Please provide either the path to Sketch file or the Figma File ID and API Key');
    }
  }

  /// Returns true if `args` contains two or more
  /// types of intake to parabeac-core
  bool _hasTooManyArgs() {
    var hasFigma =
        figmaKey != null || figmaProjectID != null || figmaOauthToken != null;
    var hasPbdl = pbdlPath != null;

    return hasFigma && hasPbdl;
  }

  /// Returns true if `args` does not contain any intake
  /// to parabeac-core
  bool _hasTooFewArgs() {
    /// Verify that we have a project ID and some sort of authentication method
    var hasFigma =
        (figmaKey != null || figmaOauthToken != null) && figmaProjectID != null;

    var hasPbdl = pbdlPath != null;

    return !(hasFigma || hasPbdl);
  }
}

enum IntegrationLevel {
  themes,
  components,
  screens,
}
