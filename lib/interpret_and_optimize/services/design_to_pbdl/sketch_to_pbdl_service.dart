import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/interpret_and_optimize/services/design_to_pbdl/design_to_pbdl_service.dart';
import 'package:pbdl/pbdl.dart';

class SketchToPBDLService implements DesignToPBDLService {
  @override
  Future<PBDLProject> callPBDL(MainInfo info) async {
    return PBDL.fromSketch(info.designFilePath, outputPath: info.outputPath);
  }

  @override
  DesignType designType = DesignType.SKETCH;
}
