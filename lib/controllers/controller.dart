import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/input/helper/asset_processing_service.dart';
import 'package:parabeac_core/input/helper/azure_asset_service.dart';
import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:quick_log/quick_log.dart';
import 'dart:convert';
import 'dart:io';
import 'main_info.dart';

abstract class Controller {
  ///SERVICE
  var log = Logger('Controller');

  Controller();

  void convertFile(
    var fileAbsPath,
    var projectPath,
    PBConfiguration configuration, {
    bool jsonOnly = false,
    DesignProject designProject,
    AssetProcessingService apService,
  }) async {
    /// IN CASE OF JSON ONLY
    if (jsonOnly) {
      return stopAndToJson(designProject, apService);
    }

    Interpret().init(projectPath, configuration);

    var pbProject = await Interpret().interpretAndOptimize(
        designProject, configuration.projectName, configuration.genProjectPath);

    var fpb = FlutterProjectBuilder(
        MainInfo().configuration.generationConfiguration,
        project: pbProject,
        pageWriter: PBFlutterWriter());

    await fpb.convertToFlutterProject();
  }

  /// Method that returns the given path and ensures
  /// it ends with a /
  String verifyPath(String path) {
    if (path.endsWith('/')) {
      return path;
    } else {
      return '$path/';
    }
  }

  Future<void> stopAndToJson(
      DesignProject project, AssetProcessingService apService) async {
    var uuids = processRootNodeUUIDs(project, apService);
    // Process rootnode UUIDs
    await apService.processRootElements(uuids);
    project.projectName = MainInfo().projectName;
    var projectJson = project.toPBDF();
    projectJson['azure_container_uri'] = AzureAssetService().getContainerUri();
    var encodedJson = json.encode(projectJson);
    File('${verifyPath(MainInfo().outputPath)}${project.projectName}.json')
        .writeAsStringSync(encodedJson);
    log.info(
        'Created PBDL JSON file at ${verifyPath(MainInfo().outputPath)}${project.projectName}.json');
  }

  /// Iterates through the [project] and returns a list of the UUIDs of the
  /// rootNodes
  Map<String, Map> processRootNodeUUIDs(
      DesignProject project, AssetProcessingService apService) {
    var result = <String, Map>{};

    for (var page in project.pages) {
      for (var screen in page.screens) {
        screen.imageURI = AzureAssetService().getImageURI('${screen.id}.png');
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
