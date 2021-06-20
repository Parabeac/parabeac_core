import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/input/helper/asset_processing_service.dart';
import 'package:parabeac_core/input/helper/azure_asset_service.dart';
import 'package:parabeac_core/input/helper/design_project.dart';

import 'controller.dart';

class DesignController extends Controller {
  @override
  DesignType get designType => DesignType.PBDL;

  @override
  void convertFile({
    DesignProject designProject,
    AssetProcessingService apService,
  }) async {
    var pbdf = MainInfo().pbdf;
    if (pbdf == null) {
      throw Error(); //todo: throw correct error
    }
    designProject ??= generateDesignProject(pbdf, MainInfo().genProjectPath);
    AzureAssetService().projectUUID = pbdf['id'];

    super.convert(designProject, apService);
  }

  DesignProject generateDesignProject(var pbdf, var proejctName) {
    return DesignProject.fromPBDF(pbdf);
  }
}
