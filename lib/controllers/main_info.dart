import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:path/path.dart' as p;
import 'package:sentry/sentry.dart';

class MainInfo {
  static final MainInfo _singleton = MainInfo._internal();

  /// Absolute path of where the flutter project is going to be generating at.
  ///
  /// If its PBC is generating the flutter project, its going to [p.join] the
  /// [outputPath] and the [projectName]. Meaning the the code should be generated
  /// into the flutter directory. Otherwise, the code is going to be generated within the directory
  /// specified in the [outputPath].
  String get genProjectPath {
    return p.join(configuration.outputPath, configuration.projectName ?? '');
  }

  /// User's platform
  String platform;

  /// Current working directory; contains the path from where the script was called
  Directory cwd;

  /// Specific [configuration] items specified by the user, or attributes that
  /// are derived straight from the configuration items that the user provided.
  ///
  /// For example, some of the configuration that are derived is the [GenerationConfiguration],
  /// based on the JSON file the user used for configuration.
  PBConfiguration configuration;

  /// Unique ID for the device running parabeac-core
  String deviceId;

  Map pbdl;

  /// Type of [DesignType] that is being processed by the current process of
  /// Parabeac Core.
  DesignType designType;

  /// Where the assets are going to be generating through the process.
  String _pngPath;
  String get pngPath => _pngPath;
  set pngPath(String path) => _pngPath = _validatePath(path ?? _defaultPNGPath);

  String get projectName => configuration.projectName;

  String get _defaultPNGPath => p.join(configuration.outputPath ?? cwd, 'pngs');

  String get outputPath => configuration.outputPath;

  Map<String, dynamic> amplitudMap = {
    'eventProperties': {
      'tags': {},
      'eggs': [],
    },
  };

  /// Checks if the [path] is `null`, if its not, it will [p.absolute] and finally,
  /// run [p.normalize] on the [path].
  ///
  /// This is primarly to enforce absolute and correct paths in the [MainInfo]
  String _validatePath(String path) {
    if (path == null) {
      return path;
    }
    return p.normalize(p.absolute(path));
  }

  /// Populates the corresponding fields of the [MainInfo] object with the
  /// corresponding [arguments].
  ///
  /// Remember that [MainInfo] is a Singleton, therefore, nothing its going to
  /// be return from the function. When you use [MainInfo] again, its going to
  /// contain the proper values from [arguments]
  void collectArguments(ArgResults arguments) {
    if (arguments['config-path'] != null) {
      final configFile = File(arguments['config-path']);
      if (configFile.existsSync()) {
        final configJson = jsonDecode(configFile.readAsStringSync());
        configuration = PBConfiguration.fromJson(configJson);
      }
    }

    configuration.mergeWithArgs(arguments);

    configuration.outputPath ??= p.dirname(Directory.current.path);

    /// Detect platform
    platform = Platform.operatingSystem;

    designType = _determineDesignTypeFromConfig();

    /// In the future when we are generating certain dart files only.
    /// At the moment we are only generating in the flutter project.
    pngPath = p.join(genProjectPath, 'lib/assets/images');

    configuration.validate();
  }

  /// Generating the [PBConfiguration] based in the configuration file in [path]
  PBConfiguration generateConfiguration(String path) {
    var configuration;
    try {
      ///SET CONFIGURATION
      // Setting configurations globally
      configuration =
          PBConfiguration.fromJson(json.decode(File(path).readAsStringSync()));
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
    }
    configuration ??= PBConfiguration.genericConfiguration();
    return configuration;
  }

  /// Determine the [MainInfo.designType] from the [arguments]
  ///
  /// If [arguments] include `figKey` or `fig`, that implies that [MainInfo.designType]
  /// should be [DesignType.FIGMA]. If there is a `path`, then the [MainInfo.designType]
  /// should be [DesignType.SKETCH]. Otherwise, if it includes the flag `pndl-in`, the type
  /// is [DesignType.PBDL].Finally, if none of the [DesignType] applies, its going to default
  /// to [DesignType.UNKNOWN].
  DesignType _determineDesignTypeFromConfig() {
    if ((configuration.figmaKey != null ||
            configuration.figmaOauthToken != null) &&
        configuration.figmaProjectID != null) {
      return DesignType.FIGMA;
    } else if (configuration.pbdlPath != null) {
      return DesignType.PBDL;
    }
    return DesignType.UNKNOWN;
  }

  factory MainInfo() {
    return _singleton;
  }

  MainInfo._internal();
}

/// The type of design that is being processed by Parabeac Core.
enum DesignType { SKETCH, FIGMA, PBDL, UNKNOWN }
