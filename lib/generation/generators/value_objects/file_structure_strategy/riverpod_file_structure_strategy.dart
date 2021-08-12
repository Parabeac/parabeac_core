import 'dart:io';
import 'package:parabeac_core/generation/flutter_project_builder/file_system_analyzer.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:path/path.dart' as p;

import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';

class RiverpodFileStructureStrategy extends FileStructureStrategy {
  final RELATIVE_PROVIDER_PATH = 'lib/riverpod/';
  final RELATIVE_MODEL_PATH = 'lib/models/';
  var _providersPath;
  var _modelsPath;

  RiverpodFileStructureStrategy(String genProjectPath, PBPageWriter pageWriter,
      PBProject pbProject, FileSystemAnalyzer fileSystemAnalyzer)
      : super(genProjectPath, pageWriter, pbProject, fileSystemAnalyzer) {
    _providersPath = p.join(genProjectPath, RELATIVE_PROVIDER_PATH);
    _modelsPath = p.join(genProjectPath, RELATIVE_MODEL_PATH);
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
    super.pageWriter.write(code, '$_modelsPath$fileName.dart'); // Removed .g
  }
}
