import 'dart:convert';
import 'dart:io';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/interpret_and_optimize/services/design_to_pbdl/design_to_pbdl_service.dart';
import 'package:pbdl/pbdl.dart';
import 'package:path/path.dart' as p;

class JsonToPBDLService implements DesignToPBDLService {
  @override
  Future<PBDLProject> callPBDL(MainInfo info) async {
    var pbdlJson =
        jsonDecode(File(MainInfo().configuration.pbdlPath).readAsStringSync());
    return await PBDL.fromJson(pbdlJson);
  }

  @override
  DesignType designType = DesignType.PBDL;
}
