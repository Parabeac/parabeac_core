import 'dart:async';

import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/generation/flutter_project_builder/file_system_analyzer.dart';
import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/input/helper/asset_processing_service.dart';
import 'package:parabeac_core/input/helper/azure_asset_service.dart';
import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:quick_log/quick_log.dart';
import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';
import 'main_info.dart';
import 'package:path/path.dart' as p;

abstract class Controller {
  /// Represents an identifier for the current [Controller] at runtime.
  ///
  /// The main way of using this is to identify what [Controller] is going to be
  /// used based on the [designType] within the `main.dart` file
  DesignType get designType;

  var log;

  Controller() {
    log = Logger(runtimeType.toString());
  }

  /// Gathering all the necessary information for the [Controller] to function
  /// properly
  ///
  /// Most, if not all, of the information will come from the [MainInfo] class.
  Future<void> setup() {
    var processInfo = MainInfo();

    /// This is currently a workaround for PB-Nest. This
    /// code usually was in the `main.dart`, however, I aggregated all
    /// the calls in the default [setup] method for the [Controller]
    if (processInfo.pbdlPath != null) {
      var pbdl = File(processInfo.pbdlPath).readAsStringSync();
      processInfo.pbdf = json.decode(pbdl);
    }
  }

  @protected

  /// Mainly used by the subclasses to convert the [designProject] to flutter code.
  ///
  /// There is a seperation of the methods because some of the [Controller]s need
  /// to generate the [designProject] based on the parameters pased to
  void convert(DesignProject designProject,
      [AssetProcessingService apService]) async {
    var processInfo = MainInfo();
    var configuration = processInfo.configuration;
    var indexFileFuture = Future.value();

    /// IN CASE OF JSON ONLY
    if (processInfo.exportPBDL) {
      return stopAndToJson(designProject, apService);
    }
    var fileSystemAnalyzer = FileSystemAnalyzer(processInfo.genProjectPath);
    fileSystemAnalyzer.addFileExtension('.dart');

    if (!(await fileSystemAnalyzer.projectExist())) {
      await FlutterProjectBuilder.createFlutterProject(processInfo.projectName,
          projectDir: processInfo.outputPath);
    } else {
      indexFileFuture = fileSystemAnalyzer.indexProjectFiles();
    }

    Interpret().init(processInfo.genProjectPath, configuration);

    var pbProject = await Interpret().interpretAndOptimize(
        designProject, processInfo.projectName, processInfo.genProjectPath);

    var fpb = FlutterProjectBuilder(
        MainInfo().configuration.generationConfiguration, fileSystemAnalyzer,
        project: pbProject, pageWriter: PBFlutterWriter());

    await indexFileFuture;
    await fpb.genProjectFiles(processInfo.genProjectPath);
  }

  void convertFile(
      {AssetProcessingService apService, DesignProject designProject});

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
