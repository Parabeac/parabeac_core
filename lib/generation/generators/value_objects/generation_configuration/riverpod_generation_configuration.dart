import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/riverpod_middleware.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/riverpod_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:quick_log/quick_log.dart';
import 'package:path/path.dart' as p;

class RiverpodGenerationConfiguration extends GenerationConfiguration {
  RiverpodGenerationConfiguration();

  @override
  Future<void> setUpConfiguration(pbProject) async {
    logger = Logger('Riverpod');
    logger.info(
        'Thanks for trying our state management configuration that is now in Beta!\nIf you run into any issues please feel free to post it in Github or in our Discord!');
    fileStructureStrategy = RiverpodFileStructureStrategy(
        pbProject.projectAbsPath,pageWriter, pbProject, fileSystemAnalyzer);
    registerMiddleware(RiverpodMiddleware(generationManager, this));
    logger.info('Setting up the directories');
    await fileStructureStrategy.setUpDirectories();
  }

  @override
  Future<void> generateProject(PBProject pb_project) async {
    await super.generateProject(pb_project);
    if (pageWriter is PBFlutterWriter) {
      (pageWriter as PBFlutterWriter).rewriteMainFunction(
        p.join(fileStructureStrategy.GENERATED_PROJECT_PATH, 'lib/main.dart'),
        _generateMainFunction(),
        imports: {FlutterImport('flutter_riverpod.dart', 'flutter_riverpod')},
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
