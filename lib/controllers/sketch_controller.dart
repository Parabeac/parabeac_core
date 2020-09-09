import 'package:archive/archive_io.dart';
import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_node_tree.dart';
import 'package:parabeac_core/input/sketch/services/input_design.dart';
import 'package:quick_log/quick_log.dart';
import 'dart:convert';
import 'dart:io';

import 'main_info.dart';

class SketchController {
  ///SERVICE
  var log = Logger('SketchController');
  void initialize() {
    ///Initialize services HERE
  }

  ///Converting the [fileAbsPath] sketch file to flutter
  void convertSketchFile(
      var fileAbsPath, var projectPath, var configurationPath) async {
    configure(configurationPath);

    ///INTAKE
    var ids = InputDesignService(fileAbsPath);
    var sketchNodeTree = generateSketchNodeTree(
        ids.archive, ids.metaFileJson['pagesAndArtboards'], projectPath);

    ///INTERPRETATION
    Interpret().init(projectPath);
    var mainTree = await Interpret().interpretAndOptimize(
      sketchNodeTree,
    );

    ///GENERATE FLUTTER CODE
    var fpb =
        FlutterProjectBuilder(projectName: projectPath, mainTree: mainTree);
    fpb.convertToFlutterProject();
  }

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

  SketchNodeTree generateSketchNodeTree(
      Archive archive, Map pagesAndArtboards, projectName) {
    try {
      return SketchNodeTree(archive, pagesAndArtboards, projectName);
    } catch (e, stackTrace) {
      MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
      return null;
    }
  }
}
