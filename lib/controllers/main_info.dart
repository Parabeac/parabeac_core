import 'dart:io';

import 'package:sentry/sentry.dart';

class MainInfo {
  static final MainInfo _singleton = MainInfo._internal();
  SentryClient sentry;

  /// Path representing where the output of parabeac-core will be produced
  String outputPath;

  /// Path to the user's sketch file
  String sketchPath;

  String platform;

  /// Current working directory; contains the path from where the script was called
  Directory cwd;
  Map<String, dynamic> configurations;

  // the type of configuration you want to set, 'default' is default type.
  String configurationType;

  /// Unique ID for the device running parabeac-core
  String deviceId;

  /// Name of the project
  String projectName;

  /// API needed to do API callls
  String figmaKey;

  /// Project ID on Figma
  String figmaProjectID;

  /// Boolean that indicates whether a `styles` document is created.
  bool exportStyles;

  Map<String, dynamic> defaultConfigs = {
    'widgetStyle': 'Material',
    'widgetType': 'Stateless',
    'widgetSpacing': 'Expanded',
    'layoutPrecedence': ['columns', 'rows', 'stack'],
    'state-management': 'None'
  };

  Map pbdf;

  factory MainInfo() {
    return _singleton;
  }

  MainInfo._internal();
}
