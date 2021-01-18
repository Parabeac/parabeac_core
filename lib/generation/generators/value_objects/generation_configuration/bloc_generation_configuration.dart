import 'package:parabeac_core/generation/generators/middleware/state_management/bloc_middleware.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/flutter_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';

class BLoCGenerationConfiguration extends GenerationConfiguration {
  BLoCGenerationConfiguration();

  @override
  Future<void> setUpConfiguration() async {
    generationManager.fileStrategy = FlutterFileStructureStrategy(
        pbProject.projectAbsPath, pageWriter, pbProject);
    registerMiddleware(BLoCMiddleware(generationManager));
    fileStructureStrategy = generationManager.fileStrategy;
    logger.info('Setting up the directories');
    await fileStructureStrategy.setUpDirectories();
    return super.setUpConfiguration();
  }
}
