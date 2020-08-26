import 'dart:io';

import 'package:sentry/sentry.dart';

class MainInfo {
  static final MainInfo _singleton = MainInfo._internal();
  SentryClient sentry;

  /// Path representing where the output of parabeac-core will be produced
  String outputPath;

  /// Path to the user's sketch file
  String sketchPath;

  /// Current working directory; contains the path from where the script was called
  Directory cwd;
  Map configurations;

  /// Unique ID for the device running parabeac-core
  String deviceId;

  Map defaultConfigs = {
    'default': {
      'widgetStyle': 'Material',
      'widgetType': 'Stateless',
      'widgetSpacing': 'Expanded',
    }
  };

  factory MainInfo() {
    return _singleton;
  }

  MainInfo._internal();
}
