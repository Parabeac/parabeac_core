import 'package:quick_log/quick_log.dart';
import 'dart:convert';
import 'dart:io';
import 'main_info.dart';

class Controller {
  ///SERVICE
  var log = Logger('Controller');

  Controller();

  void convertFile(var fileAbsPath, var projectPath, var configurationPath) {}

  void configure(var configurationPath) async {
    Map configurations;
    try {
      if (configurationPath == null || configurationPath.isEmpty) {
        configurations = MainInfo().defaultConfigs;
      } else {
        configurations =
            json.decode(File(configurationPath).readAsStringSync());
      }
    } catch (e, stackTrace) {
      // await MainInfo().sentry.captureException(
      //       exception: e,
      //       stackTrace: stackTrace,
      //     );
      log.error(e.toString());
    }

    ///SET CONFIGURATION
    // Setting configurations globaly
    MainInfo().configurations = configurations;
  }
}
