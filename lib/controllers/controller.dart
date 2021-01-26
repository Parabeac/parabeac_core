import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:quick_log/quick_log.dart';
import 'dart:convert';
import 'dart:io';
import 'main_info.dart';

abstract class Controller {
  ///SERVICE
  var log = Logger('Controller');

  Controller();

  void convertFile(
      var fileAbsPath, var projectPath, var configurationPath, var configType,
      {bool jsonOnly});

  void configure(var configurationPath, var configType) async {
    Map configurations;
    try {
      if (configurationPath == null || configurationPath.isEmpty) {
        configurations = MainInfo().defaultConfigs;
      } else {
        configurations =
            json.decode(File(configurationPath).readAsStringSync());
      }
    } catch (e, stackTrace) {
      await MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
    }

    ///SET CONFIGURATION
    // Setting configurations globally
    MainInfo().configurations = configurations;
    MainInfo().configurationType = configType;
  }

  void stopAndToJson(DesignProject project);

  String verifyPath(String path) {
    if (path.endsWith('/')) {
      return path;
    } else {
      return '${path}/';
    }
  }
}
