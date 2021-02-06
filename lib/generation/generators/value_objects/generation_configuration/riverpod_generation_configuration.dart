import 'package:parabeac_core/generation/generators/middleware/state_management/riverpod_middleware.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/riverpod_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:quick_log/quick_log.dart';

class RiverpodGenerationConfiguration extends GenerationConfiguration {
  RiverpodGenerationConfiguration();

  @override
  Future<void> setUpConfiguration() async {
    logger = Logger('Riverpod');
    logger.info(
        'Thanks for trying our state management configuration that is now in Beta!\nIf you run into any issues please feel free to post it in Github or in our Discord!');
    fileStructureStrategy = RiverpodFileStructureStrategy(
        pbProject.projectAbsPath, pageWriter, pbProject);
    registerMiddleware(RiverpodMiddleware(generationManager));
    logger.info('Setting up the directories');
    await fileStructureStrategy.setUpDirectories();
  }
}
