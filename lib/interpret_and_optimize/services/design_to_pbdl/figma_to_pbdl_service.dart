import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/interpret_and_optimize/services/design_to_pbdl/design_to_pbdl_service.dart';
import 'package:pbdl/pbdl.dart';
import 'package:path/path.dart' as p;

class FigmaToPBDLService implements DesignToPBDLService {
  @override
  DesignType designType = DesignType.FIGMA;

  @override
  Future<PBDLProject> callPBDL(MainInfo info) => PBDL.fromFigma(
        info.figmaProjectID,
        info.figmaKey,
        outputPath: p.join(info.outputPath, 'assets'),
      );
}
