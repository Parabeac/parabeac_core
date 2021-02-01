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
    var configurationPath,
    var configType, {
    bool jsonOnly = false,
    DesignProject designProject,
    AssetProcessingService apService,
  }) async {
    configure(configurationPath, configType);

    var designProject = await generateDesignProject(pbdf, outputPath);
    AzureAssetService().projectUUID = pbdf['id'];

    await super.convertFile(
      pbdf,
      outputPath,
      configurationPath,
      configType,
      designProject: designProject,
      jsonOnly: jsonOnly,
    );
  }

  DesignProject generateDesignProject(var pbdf, var proejctName) {
    return DesignProject.fromPBDF(pbdf);
  }
}
