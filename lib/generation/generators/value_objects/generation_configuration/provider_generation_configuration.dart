import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/provider_middleware.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/provider_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:quick_log/quick_log.dart';
import 'package:recase/recase.dart';
import 'package:path/path.dart' as p;

class ProviderGenerationConfiguration extends GenerationConfiguration {
  ProviderGenerationConfiguration();

  Set<String> registeredModels = {};

  @override
  Future<void> setUpConfiguration(pbProject) async {
    logger = Logger('Provider');
    logger.info(
        'Thanks for trying our state management configuration that is now in Beta!\nIf you run into any issues please feel free to post it in Github or in our Discord!');
    fileStructureStrategy = ProviderFileStructureStrategy(
        pbProject.projectAbsPath, pageWriter, pbProject);
    registerMiddleware(ProviderMiddleware(generationManager, this));
    logger.info('Setting up the directories');
    await fileStructureStrategy.setUpDirectories();
  }

  @override
  Future<void> generateProject(PBProject pb_project) async {
    await super.generateProject(pb_project);
    Set imports = <FlutterImport>{FlutterImport('provider.dart', 'provider')};
    imports.addAll(registeredModels
        .map((e) => FlutterImport(
            p.setExtension(
                p.join(fileStructureStrategy.GENERATED_PROJECT_PATH, 'models',
                    e.snakeCase),
                '.dart'),
            pb_project.projectName))
        .toList());
  }
}
