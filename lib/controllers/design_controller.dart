import 'package:parabeac_core/input/helper/asset_processing_service.dart';
import 'package:parabeac_core/input/helper/azure_asset_service.dart';
import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:quick_log/quick_log.dart';

import 'controller.dart';

class DesignController extends Controller {
  @override
  var log = Logger('FigmaController');

  DesignController();

  @override
  void convertFile(
    var pbdf,
    var outputPath,
    configuration, {
    bool jsonOnly = false,
    DesignProject designProject,
    AssetProcessingService apService,
  }) async {
    var designProject = generateDesignProject(pbdf, outputPath);
    AzureAssetService().projectUUID = pbdf['id'];

    super.convertFile(
      pbdf,
      outputPath,
      configuration,
      designProject: designProject,
      jsonOnly: jsonOnly,
    );
  }

  DesignProject generateDesignProject(var pbdf, var proejctName) {
    return DesignProject.fromPBDF(pbdf);
  }
}
