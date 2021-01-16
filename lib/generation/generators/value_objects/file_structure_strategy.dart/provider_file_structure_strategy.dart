import 'dart:io';

import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/pb_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

class ProviderFileStructureStrategy extends FileStructureStrategy {
  final RELATIVE_PROVIDER_PATH = 'providers/';
  final RELATIVE_MODEL_PATH = 'models/';
  var _providersPath;
  var _modelsPath;

  ProviderFileStructureStrategy(String genProjectPath, PBPageWriter pageWriter,
      PBIntermediateTree projectIntermediateTree)
      : super(genProjectPath, pageWriter, projectIntermediateTree) {
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

  void writeProviderModelFile(String code, String fileName) {
    super.pageWriter.write(code, '${_modelsPath}${fileName}.g.dart');
  }
}
