import 'dart:io';
import 'dart:convert';

import 'package:parabeac_core/controllers/controller.dart';
import 'package:parabeac_core/input/helper/asset_processing_service.dart';
import 'package:parabeac_core/input/helper/azure_asset_service.dart';

import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_asset_processor.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_project.dart';
import 'package:parabeac_core/input/sketch/services/input_design.dart';

import 'main_info.dart';
import 'package:path/path.dart' as p;

class SketchController extends Controller {
  @override
  DesignType get designType => DesignType.SKETCH;

  ///Converting the [fileAbsPath] sketch file to flutter
  @override
  void convertFile({
    DesignProject designProject,
    AssetProcessingService apService,
  }) async {
    var processInfo = MainInfo();

    ///INTAKE
    var ids = InputDesignService(processInfo.designFilePath,
        jsonOnly: processInfo.exportPBDL);
    designProject ??= generateSketchNodeTree(
        ids, ids.metaFileJson['pagesAndArtboards'], processInfo.genProjectPath);

    AzureAssetService().projectUUID = designProject.id;

    super.convert(designProject, apService ?? SketchAssetProcessor());
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

  @override
  Future<void> setup() async {
    var processInfo = MainInfo();
    if (!processInfo.exportPBDL) {
      if (!FileSystemEntity.isFileSync(processInfo.designFilePath)) {
        throw Error();
      }
      InputDesignService(processInfo.designFilePath);
      await checkSACVersion();
    }
    await super.setup();
  }

  Future<void> checkSACVersion() async {
    /// Code is moved from `main.dart`
    Process process;
    if (!Platform.environment.containsKey('SAC_ENDPOINT')) {
      var isSACupToDate = await Process.run(
        './pb-scripts/check-git.sh',
        [],
        workingDirectory: MainInfo().cwd.path,
      );

      if (isSACupToDate.stdout
          .contains('Sketch Asset Converter is behind master.')) {
        log.warning(isSACupToDate.stdout);
      } else {
        log.info(isSACupToDate.stdout);
      }

      process = await Process.start('npm', ['run', 'prod'],
          workingDirectory:
              p.join(MainInfo().cwd.path, 'SketchAssetConverter'));

      await for (var event in process.stdout.transform(utf8.decoder)) {
        if (event.toLowerCase().contains('server is listening on port')) {
          log.fine('Successfully started Sketch Asset Converter');
          break;
        }
      }
      process?.kill();
    }
  }
}
