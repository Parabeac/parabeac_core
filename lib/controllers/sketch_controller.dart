import 'package:parabeac_core/controllers/controller.dart';
import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/writers/pb_traversal_adapter_writer.dart';
import 'package:parabeac_core/generation/pre-generation/pre_generation_service.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_node_tree.dart';
import 'package:parabeac_core/input/sketch/services/input_design.dart';
import 'package:quick_log/quick_log.dart';

import 'main_info.dart';

class SketchController extends Controller {
  ///SERVICE
  @override
  var log = Logger('SketchController');

  ///Converting the [fileAbsPath] sketch file to flutter
  @override
  void convertFile(var fileAbsPath, var projectPath, var configurationPath,
      var configType) async {
    configure(configurationPath, configType);

    ///INTAKE
    var ids = InputDesignService(fileAbsPath);
    var sketchNodeTree = generateSketchNodeTree(
        ids, ids.metaFileJson['pagesAndArtboards'], projectPath);

    ///INTERPRETATION
    Interpret().init(projectPath);
    var mainTree = await Interpret().interpretAndOptimize(
      sketchNodeTree,
    );

    // TODO: ensure manager is populated

    ///PRE-GENERATION SERVICE
    await PreGenerationService(
      projectName: projectPath,
      mainTree: mainTree,
      pageWriter: PBTraversalAdapterWriter(),
    ).convertToFlutterProject();

    ///GENERATE FLUTTER CODE
    var fpb = FlutterProjectBuilder(
        projectName: projectPath,
        mainTree: mainTree,
        pageWriter: PBFlutterWriter());
    fpb.convertToFlutterProject();
  }

  SketchNodeTree generateSketchNodeTree(
      InputDesignService ids, Map pagesAndArtboards, projectName) {
    try {
      return SketchNodeTree(ids, pagesAndArtboards, projectName);
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
