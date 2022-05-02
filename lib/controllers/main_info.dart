import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:path/path.dart' as p;
import 'package:sentry/sentry.dart';

class MainInfo {
  static final MainInfo _singleton = MainInfo._internal();

  /// Path representing where the output of parabeac-core will be produced to.
  ///
  /// First, we are going to check the if any path was passed as a flag to [outputPath],
  /// then check in the [configuration] to see if there are any paths saved ([PBConfiguration.outputDirPath]).
  String _outputPath;
  String get outputPath => _outputPath ?? configuration?.outputDirPath;
  set outputPath(String path) => _outputPath = _validatePath(path);

  /// Path to the user's sketch file
  String _designFilePath;
  String get designFilePath => _designFilePath;
  set designFilePath(String path) => _designFilePath = _validatePath(path);

  /// Absolute path of where the flutter project is going to be generating at.
  ///
  /// If its PBC is generating the flutter project, its going to [p.join] the
  /// [outputPath] and the [projectName]. Meaning the the code should be generated
  /// into the flutter directory. Otherwise, the code is going to be generated within the directory
  /// specified in the [outputPath].
  String get genProjectPath {
    return p.join(outputPath, projectName ?? '');
  }

  String platform;

  /// Current working directory; contains the path from where the script was called
  Directory cwd;

  /// The path of where the PBDL file is at.
  String _pbdlPath;
  String get pbdlPath => _pbdlPath;
  set pbdlPath(String path) => _pbdlPath = _validatePath(path);

  /// Specific [configuration] items specified by the user, or attributes that
  /// are derived straight from the configuration items that the user provided.
  ///
  /// For example, some of the configuration that are derived is the [GenerationConfiguration],
  /// based on the JSON file the user used for configuration.
  PBConfiguration configuration;

  // the type of configuration you want to set, 'default' is default type.
  String configurationType;

  /// Unique ID for the device running parabeac-core
  String deviceId;

  /// Name of the project
  String _projectName;
  String get projectName => _projectName ?? configuration?.projectName;
  set projectName(String name) => _projectName = name;

  /// OAuth Token to call Figma API
  String figmaOauthToken;

  /// API key needed to do API calls
  String figmaKey;

  /// Project ID on Figma
  String figmaProjectID;

  /// Boolean that indicates whether a `styles` document is created.
  bool exportStyles;

  /// Exporting the PBDL JSON file instead of generating the actual Flutter code.
  bool exportPBDL;

  Map pbdl;

  /// Type of [DesignType] that is being processed by the current process of
  /// Parabeac Core.
  DesignType designType;

  /// Where the assets are going to be generating through the process.
  String _pngPath;
  String get pngPath => _pngPath;
  set pngPath(String path) => _pngPath = _validatePath(path ?? _defaultPNGPath);

  String get _defaultPNGPath => p.join(outputPath ?? cwd, 'pngs');

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
    var info = MainInfo();

    info.configuration =
        generateConfiguration(p.normalize(arguments['config-path']));

    /// Detect platform
    info.platform = Platform.operatingSystem;

    info.figmaOauthToken = arguments['oauth'];
    info.figmaKey = arguments['figKey'];
    info.figmaProjectID = arguments['fig'];

    info.designFilePath = arguments['path'];
    if (arguments['pbdl-in'] != null) {
      info.pbdlPath = arguments['pbdl-in'];
    }

    info.designType = determineDesignTypeFromArgs(arguments);
    info.exportStyles = !arguments['exclude-styles'];
    info.projectName ??= arguments['project-name'];

    /// If outputPath is empty, assume we are outputting to design file path
    info.outputPath = arguments['out'] ??
        p.dirname(info.designFilePath ?? Directory.current.path);

    info.exportPBDL = arguments['export-pbdl'] ?? false;

    /// In the future when we are generating certain dart files only.
    /// At the moment we are only generating in the flutter project.
    info.pngPath = p.join(info.genProjectPath, 'lib/assets/images');
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
  DesignType determineDesignTypeFromArgs(ArgResults arguments) {
    if ((arguments['figKey'] != null || arguments['oauth'] != null) &&
        arguments['fig'] != null) {
      return DesignType.FIGMA;
    } else if (arguments['path'] != null) {
      return DesignType.SKETCH;
    } else if (arguments['pbdl-in'] != null) {
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
