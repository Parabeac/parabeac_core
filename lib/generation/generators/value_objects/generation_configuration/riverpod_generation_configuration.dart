import 'package:parabeac_core/generation/generators/middleware/state_management/riverpod_middleware.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/riverpod_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:quick_log/quick_log.dart';

class RiverpodGenerationConfiguration extends GenerationConfiguration {
  RiverpodGenerationConfiguration();

  @override
  Future<void> setUpConfiguration(pbProject) async {
    logger = Logger('Riverpod');
    logger.info(
        'Thanks for trying our state management configuration that is now in Beta!\nIf you run into any issues please feel free to post it in Github or in our Discord!');
    fileStructureStrategy = RiverpodFileStructureStrategy(
        pbProject.projectAbsPath, pageWriter, pbProject);
    registerMiddleware(RiverpodMiddleware(generationManager));
    logger.info('Setting up the directories');
    await fileStructureStrategy.setUpDirectories();
  }

  @override
  Future<void> generateProject(PBProject pb_project) async {
    await super.generateProject(pb_project);
    if (pageWriter is PBFlutterWriter) {
      (pageWriter as PBFlutterWriter).rewriteMainFunction(
        fileStructureStrategy.GENERATED_PROJECT_PATH + 'lib/main.dart',
        _generateMainFunction(),
        imports: {"import 'package:flutter_riverpod/flutter_riverpod.dart';"},
      );
    }
  }

  String _generateMainFunction() {
    return '''
    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
    ''';
  }
}
