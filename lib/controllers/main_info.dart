import 'dart:io';

import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:sentry/sentry.dart';
import 'package:path/path.dart' as p;

class MainInfo {
  static final MainInfo _singleton = MainInfo._internal();
  
  final SentryClient _sentry = SentryClient(
      dsn:
          'https://6e011ce0d8cd4b7fb0ff284a23c5cb37@o433482.ingest.sentry.io/5388747');

  @Deprecated('Use the function handle error for logging and capturing the error')
  SentryClient get sentry => _sentry;

  /// Path representing where the output of parabeac-core will be produced to.
  /// 
  /// First, we are going to check the if any path was passed as a flag to [outputPath], 
  /// then check in the [configuration] to see if there are any paths saved ([PBConfiguration.outputDirPath]).
  String _outputPath;
  String get outputPath =>  _outputPath ?? configuration?.outputDirPath;
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

  /// API needed to do API callls
  String figmaKey;

  /// Project ID on Figma
  String figmaProjectID;

  /// Boolean that indicates whether a `styles` document is created.
  bool exportStyles;

  /// Exporting the PBDL JSON file instead of generating the actual Flutter code.
  bool exportPBDL;

  Map pbdf;

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

  /// Decoupling the exception capture client from the services that report the [exception]
  void captureException(exception) {
    _sentry.captureException(exception: exception);
  }

  factory MainInfo() {
    return _singleton;
  }

  MainInfo._internal();
}

/// The type of design that is being processed by Parabeac Core.
enum DesignType { SKETCH, FIGMA, PBDL, UNKNOWN }
