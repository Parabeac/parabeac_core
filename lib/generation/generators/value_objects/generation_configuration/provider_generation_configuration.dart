import 'package:parabeac_core/generation/generators/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/state_management_wrappers/provider_generator_wrapper.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/provider_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';

class ProviderGenerationConfiguration extends GenerationConfiguration {
  ProviderGenerationConfiguration() {
    registerMiddleware(ProviderMiddleware());
  }
  @override
  Future<void> setUpConfiguration() async {
    fileStructureStrategy = ProviderFileStructureStrategy(
        intermediateTree.projectAbsPath, PBFlutterWriter(), intermediateTree);
    logger.info('Setting up the directories');
    await fileStructureStrategy.setUpDirectories();
  }
}
