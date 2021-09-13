import 'package:parabeac_core/controllers/main_info.dart';
import 'package:pbdl/pbdl.dart';

abstract class DesignToPBDLService {
  DesignType designType;

  Future<PBDLProject> callPBDL(MainInfo info);
}
