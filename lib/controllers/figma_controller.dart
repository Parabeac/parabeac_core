import 'package:parabeac_core/controllers/controller.dart';
import 'package:parabeac_core/input/figma/entities/layers/frame.dart';
import 'package:parabeac_core/input/figma/helper/figma_asset_processor.dart';
import 'package:parabeac_core/input/figma/helper/figma_project.dart';
import 'package:parabeac_core/input/helper/asset_processing_service.dart';
import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:quick_log/quick_log.dart';

import 'interpret.dart';

class FigmaController extends Controller {
  ///SERVICE
  @override
  var log = Logger('FigmaController');

  FigmaController();

  @override
  void convertFile(
    var jsonFigma,
    var outputPath,
    var configurationPath,
    var configType, {
    bool jsonOnly = false,
    DesignProject designProject,
    AssetProcessingService apService,
  }) async {
    configure(configurationPath, configType);

    var figmaProject = await generateFigmaTree(jsonFigma, outputPath);

    figmaProject = declareScaffolds(figmaProject);

    await super.convertFile(
      jsonFigma,
      outputPath,
      configurationPath,
      configType,
      designProject: figmaProject,
      jsonOnly: jsonOnly,
      apService: apService,
    );
  }

  FigmaProject generateFigmaTree(var jsonFigma, var projectname) {
    try {
      return FigmaProject(projectname, jsonFigma);
    } catch (e, stackTrace) {
      print(e);
      return null;
    }
  }

  /// This method was required for Figma, so we could
  /// detect which `FigmaFrame` were Scaffolds or Containers
  FigmaProject declareScaffolds(FigmaProject tree) {
    for (var page in tree.pages) {
      for (var item in page.getPageItems()) {
        if (item.designNode is FigmaFrame) {
          (item.designNode as FigmaFrame).isScaffold = true;
        }
      }
    }
    return tree;
  }
}
