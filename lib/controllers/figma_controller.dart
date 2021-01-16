import 'package:parabeac_core/controllers/controller.dart';
import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/writers/pb_traversal_adapter_writer.dart';
import 'package:parabeac_core/generation/pre-generation/pre_generation_service.dart';
import 'package:parabeac_core/input/figma/entities/layers/frame.dart';
import 'package:parabeac_core/input/figma/helper/figma_node_tree.dart';
import 'package:quick_log/quick_log.dart';

import 'interpret.dart';

class FigmaController extends Controller {
  ///SERVICE
  @override
  var log = Logger('FigmaController');

  FigmaController();

  @override
  void convertFile(var jsonFigma, var outputPath, var configurationPath,
      var configType) async {
    configure(configurationPath, configType);

    var figmaNodeTree = await generateFigmaTree(jsonFigma, outputPath);

    figmaNodeTree = declareScaffolds(figmaNodeTree);

    Interpret().init(outputPath);

    var mainTree = await Interpret().interpretAndOptimize(figmaNodeTree);

    await PreGenerationService(
      projectName: outputPath,
      mainTree: mainTree,
      pageWriter: PBTraversalAdapterWriter(),
    ).convertToFlutterProject();

    var fpb = FlutterProjectBuilder(
        projectName: outputPath,
        mainTree: mainTree,
        pageWriter: PBFlutterWriter());

    fpb.convertToFlutterProject();
  }

  FigmaNodeTree generateFigmaTree(var jsonFigma, var projectname) {
    try {
      return FigmaNodeTree(projectname, jsonFigma);
    } catch (e, stackTrace) {
      print(e);
      return null;
    }
  }

  /// This method was required for Figma, so we could
  /// detect which `FigmaFrame` were Scaffolds or Containers
  FigmaNodeTree declareScaffolds(FigmaNodeTree tree) {
    for (var page in tree.pages) {
      for (var item in page.getPageItems()) {
        if (item.root is FigmaFrame) {
          (item.root as FigmaFrame).isScaffold = true;
        }
      }
    }
    return tree;
  }
}
