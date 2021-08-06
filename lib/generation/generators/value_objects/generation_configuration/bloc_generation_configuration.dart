import 'package:parabeac_core/generation/generators/middleware/state_management/bloc_middleware.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/bloc_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:quick_log/quick_log.dart';

class BLoCGenerationConfiguration extends GenerationConfiguration {
  BLoCGenerationConfiguration();

  @override
  Future<void> setUpConfiguration(pbProject) async {
    await super.setUpConfiguration(pbProject);
    logger = Logger('BLoC');
    logger.info(
        'Thanks for trying our state management configuration that is now in Beta!\nIf you run into any issues please feel free to post it in Github or in our Discord!');
    fileStructureStrategy = BLoCFileStructureStrategy(
        pbProject.projectAbsPath, pageWriter, pbProject, fileSystemAnalyzer);
    registerMiddleware(BLoCMiddleware(generationManager, this));
    logger.info('Setting up the directories');
    await fileStructureStrategy.setUpDirectories();
  }
}
