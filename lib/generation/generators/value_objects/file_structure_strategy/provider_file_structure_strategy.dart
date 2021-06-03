import 'dart:io';

import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';

class ProviderFileStructureStrategy extends FileStructureStrategy {
  final RELATIVE_MODEL_PATH = 'lib/models/';
  var _modelsPath;

  ProviderFileStructureStrategy(
      String genProjectPath, PBPageWriter pageWriter, PBProject pbProject)
      : super(genProjectPath, pageWriter, pbProject) {
    _modelsPath = '$genProjectPath$RELATIVE_MODEL_PATH';
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
    Directory(_modelsPath).createSync(recursive: true);
  }

  void writeProviderModelFile(String code, String fileName) {
    super
        .pageWriter
        .write(code, '$_modelsPath$fileName.dart'); // Removed .g
  }
}
