import 'dart:io';

import 'package:yaml_modify/yaml_modify.dart';

/// Class that is in charge of interacting with the public yaml file.
class PubspecUtils {
  /// TODO: Add all methods that edit or read the yaml file.

  String pubspecAbsolutePath;

  PubspecUtils(this.pubspecAbsolutePath);

  /// Method that returns the version inside the pubspec.yaml file.
  String getPackageVersion() {
    var pubspecStr = File(pubspecAbsolutePath).readAsStringSync();

    Map pubspec = loadYaml(pubspecStr);

    return pubspec['version'];
  }
}
