import 'package:parabeac_core/generation/generators/middleware/state_management/provider_middleware.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/provider_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';

class ProviderGenerationConfiguration extends GenerationConfiguration {
  ProviderGenerationConfiguration();

  @override
  Future<void> setUpConfiguration() async {
    generationManager.fileStrategy = ProviderFileStructureStrategy(
        intermediateTree.projectAbsPath, PBFlutterWriter(), intermediateTree);
    registerMiddleware(ProviderMiddleware(generationManager));
    fileStructureStrategy = generationManager.fileStrategy;
    logger.info('Setting up the directories');
    await fileStructureStrategy.setUpDirectories();
  }
}
