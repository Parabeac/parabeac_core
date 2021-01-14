import 'package:parabeac_core/generation/generators/middleware/state_management/stateful_middleware.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/flutter_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';

import '../../writers/pb_flutter_writer.dart';

class StatefulGenerationConfiguration extends GenerationConfiguration {
  StatefulGenerationConfiguration();

  @override
  Future<void> setUpConfiguration() async {
    generationManager.fileStrategy = FlutterFileStructureStrategy(
        intermediateTree.projectAbsPath, PBFlutterWriter(), intermediateTree);
    registerMiddleware(StatefulMiddleware(generationManager));
    fileStructureStrategy = generationManager.fileStrategy;
    logger.info('Setting up the directories');
    await fileStructureStrategy.setUpDirectories();
    return super.setUpConfiguration();
  }
}
