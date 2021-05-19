import 'package:parabeac_core/controllers/controller.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/input/figma/entities/layers/component.dart';
import 'package:parabeac_core/input/figma/entities/layers/frame.dart';
import 'package:parabeac_core/input/figma/helper/figma_project.dart';
import 'package:parabeac_core/input/helper/asset_processing_service.dart';
import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:quick_log/quick_log.dart';

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

    var figmaProject = generateFigmaTree(jsonFigma, outputPath);

    figmaProject = declareScaffolds(figmaProject);

    _sortPages(figmaProject);

    super.convertFile(
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
      return FigmaProject(
        projectname,
        jsonFigma,
        id: MainInfo().figmaProjectID,
      );
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

  /// Sorts project's pages so that Components are processed last
  void _sortPages(FigmaProject project) {
    // Sort pages so that pages containing components are last
    project.pages.sort((a, b) {
      if (a.screens.any((screen) => screen.designNode is Component)) {
        return 1;
      } else if (b.screens.any((screen) => screen.designNode is Component)) {
        return -1;
      }
      return 0;
    });

    // Within each page, ensure screens that are components go last
    project.pages.forEach((page) {
      page.screens.sort((a, b) {
        if (a.designNode is Component) {
          return 1;
        } else if (b.designNode is Component) {
          return -1;
        }
        return 0;
      });
    });
  }
}
