import 'package:parabeac_core/controllers/controller.dart';
import 'package:parabeac_core/input/helper/asset_processing_service.dart';
import 'package:parabeac_core/input/helper/azure_asset_service.dart';

import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_project.dart';
import 'package:parabeac_core/input/sketch/services/input_design.dart';
import 'package:quick_log/quick_log.dart';

import 'main_info.dart';

class SketchController extends Controller {
  ///SERVICE
  @override
  var log = Logger('SketchController');

  ///Converting the [fileAbsPath] sketch file to flutter
  @override
  void convertFile(
    var fileAbsPath,
    var projectPath,
    var configurationPath,
    var configType, {
    bool jsonOnly = false,
    DesignProject designProject,
    AssetProcessingService apService,
  }) async {
    configure(configurationPath, configType);

    ///INTAKE
    var ids = InputDesignService(fileAbsPath, jsonOnly: jsonOnly);
    var sketchProject = generateSketchNodeTree(
        ids, ids.metaFileJson['pagesAndArtboards'], projectPath);

    AzureAssetService().projectUUID = sketchProject.id;

    await super.convertFile(
      fileAbsPath,
      projectPath,
      configurationPath,
      configType,
      designProject: sketchProject,
      jsonOnly: jsonOnly,
      apService: apService,
    );
  }

  SketchProject generateSketchNodeTree(
      InputDesignService ids, Map pagesAndArtboards, projectName) {
    try {
      return SketchProject(ids, pagesAndArtboards, projectName);
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
