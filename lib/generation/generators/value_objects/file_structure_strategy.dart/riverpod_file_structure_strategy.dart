import 'dart:io';

import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';

class RiverpodFileStructureStrategy extends FileStructureStrategy {
  final RELATIVE_PROVIDER_PATH = 'lib/riverpod/';
  final RELATIVE_MODEL_PATH = 'lib/models/';
  var _providersPath;
  var _modelsPath;

  RiverpodFileStructureStrategy(
      String genProjectPath, PBPageWriter pageWriter, PBProject pbProject)
      : super(genProjectPath, pageWriter, pbProject) {
    _providersPath = '${genProjectPath}${RELATIVE_PROVIDER_PATH}';
    _modelsPath = '${genProjectPath}${RELATIVE_MODEL_PATH}';
  }

  @override
  Future<void> setUpDirectories() async {
    if (!isSetUp) {
      await Future.wait(
          [super.setUpDirectories(), _generateMissingDirectories()]);
      isSetUp = true;
    }
  }

  Future<void> _generateMissingDirectories() async {
    Directory(_providersPath).createSync(recursive: true);
    Directory(_modelsPath).createSync(recursive: true);
  }

  void writeRiverpodModelFile(String code, String fileName) {
    // don't overwrite the model file as user could have changed it
    // only create the first time
    if (!File('$_modelsPath$fileName.dart').existsSync()) {
      super
          .pageWriter
          .write(code, '$_modelsPath$fileName.dart'); // Removed .g
    }
  }
}
