import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/writers/pb_traversal_adapter_writer.dart';
import 'package:parabeac_core/generation/pre-generation/pre_generation_service.dart';
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
    var fileAbsPath,
    var projectPath,
    var configurationPath,
    var configType, {
    bool jsonOnly = false,
    DesignProject designProject,
  }) async {
    /// IN CASE OF JSON ONLY
    if (jsonOnly) {
      return stopAndToJson(designProject);
    }

    Interpret().init(projectPath);

    var pbProject = await Interpret().interpretAndOptimize(designProject);

    pbProject.forest.forEach((tree) => tree.data = PBGenerationViewData());

    await PreGenerationService(
      projectName: projectPath,
      mainTree: pbProject,
      pageWriter: PBTraversalAdapterWriter(),
    ).convertToFlutterProject();

    //Making the data immutable for writing into the file
    pbProject.forest.forEach((tree) => tree.data.lockData());

    var fpb = FlutterProjectBuilder(
        projectName: projectPath,
        mainTree: pbProject,
        pageWriter: PBFlutterWriter());

    await fpb.convertToFlutterProject();
  }

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

  void stopAndToJson(DesignProject project) {
    project.projectName = MainInfo().projectName;
    var encodedJson = json.encode(project.toPBDF());
    File('${verifyPath(MainInfo().outputPath)}${project.projectName}.json')
        .writeAsStringSync(encodedJson);
    print('Output JSON');
  }
}
