import 'dart:convert';
import 'dart:io';

import 'package:parabeac_core/controllers/controller.dart';
import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/writers/pb_traversal_adapter_writer.dart';
import 'package:parabeac_core/generation/pre-generation/pre_generation_service.dart';
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
      var fileAbsPath, var projectPath, var configurationPath, var configType,
      {bool jsonOnly}) async {
    configure(configurationPath, configType);

    ///INTAKE
    var ids = InputDesignService(fileAbsPath);
    var sketchProject = generateSketchNodeTree(
        ids, ids.metaFileJson['pagesAndArtboards'], projectPath);

    /// IN CASE OF JSON ONLY
    if (jsonOnly) {
      return stopAndToJson(sketchProject);
    }

    ///INTERPRETATION
    Interpret().init(projectPath);
    var pbProject = await Interpret().interpretAndOptimize(
      sketchProject,
    );
    pbProject.forest.forEach((tree) => tree.data = PBGenerationViewData());

    ///PRE-GENERATION SERVICE
    var pgs = PreGenerationService(
      projectName: projectPath,
      mainTree: pbProject,
      pageWriter: PBTraversalAdapterWriter(),
    );
    await pgs.convertToFlutterProject();

    //Making the data immutable for writing into the file
    pbProject.forest.forEach((tree) => tree.data.lockData());

    ///GENERATE FLUTTER CODE
    var fpb = FlutterProjectBuilder(
        projectName: projectPath,
        mainTree: pbProject,
        pageWriter: PBFlutterWriter());
    await fpb.convertToFlutterProject();
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
