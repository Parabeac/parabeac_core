import 'package:parabeac_core/controllers/controller.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/input/figma/entities/layers/component.dart';
import 'package:parabeac_core/input/figma/entities/layers/frame.dart';
import 'package:parabeac_core/input/figma/helper/api_call_service.dart';
import 'package:parabeac_core/input/figma/helper/figma_asset_processor.dart';
import 'package:parabeac_core/input/figma/helper/figma_project.dart';
import 'package:parabeac_core/input/helper/asset_processing_service.dart';
import 'package:parabeac_core/input/helper/azure_asset_service.dart';
import 'package:parabeac_core/input/helper/design_project.dart';

class FigmaController extends Controller {
  @override
  DesignType get designType => DesignType.FIGMA;

  @override
  void convertFile({
    DesignProject designProject,
    AssetProcessingService apService,
  }) async {
    var jsonFigma = await _fetchFigmaFile();
    if (jsonFigma == null) {
      throw Error(); //todo: find correct error
    }
    AzureAssetService().projectUUID = MainInfo().figmaProjectID;
    designProject ??= generateFigmaTree(jsonFigma, MainInfo().genProjectPath);
    designProject = declareScaffolds(designProject);

    _sortPages(designProject);
    super.convert(designProject, apService ?? FigmaAssetProcessor());
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

  Future<dynamic> _fetchFigmaFile() => APICallService.makeAPICall(
      'https://api.figma.com/v1/files/${MainInfo().figmaProjectID}',
      MainInfo().figmaKey);

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

  @override
  Future<void> setup() async {
    var processInfo = MainInfo();
    if (processInfo.figmaKey == null || processInfo.figmaProjectID == null) {
      throw Error(); //todo: place correct error
    }
  }
}
