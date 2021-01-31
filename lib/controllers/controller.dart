import 'package:parabeac_core/input/helper/asset_processing_service.dart';
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

  /// Method that returns the given path and ensures
  /// it ends with a /
  String verifyPath(String path) {
    if (path.endsWith('/')) {
      return path;
    } else {
      return '${path}/';
    }
  }

  Future<void> stopAndToJson(
      DesignProject project, AssetProcessingService apService) async {
    var uuids = processRootNodeUUIDs(project);
    // Process rootnode UUIDs
    await apService.processRootElements(uuids);
    project.projectName = MainInfo().projectName;
    var projectJson = project.toJson();
    projectJson['azure_uri'] = apService.getContainerUri();
    var encodedJson = json.encode(projectJson);
    File('${verifyPath(MainInfo().outputPath)}${project.projectName}.json')
        .writeAsStringSync(encodedJson);
    log.info(
        'Created PBDL JSON file at ${verifyPath(MainInfo().outputPath)}${project.projectName}.json');
  }

  /// Iterates through the [project] and returns a list of the UUIDs of the
  /// rootNodes
  Map<String, Map> processRootNodeUUIDs(DesignProject project) {
    var result = <String, Map>{};

    for (var page in project.pages) {
      for (var screen in page.screens) {
        result[screen.id] = {
          'width': screen.designNode.boundaryRectangle.width,
          'height': screen.designNode.boundaryRectangle.height
        };
      }
    }

    for (var page in project.miscPages) {
      for (var screen in page.screens) {
        result[screen.id] = {
          'width': screen.designNode.boundaryRectangle.width,
          'height': screen.designNode.boundaryRectangle.height
        };
      }
    }

    return result;
  }
}
