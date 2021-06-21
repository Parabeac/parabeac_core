import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/provider_middleware.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/provider_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:quick_log/quick_log.dart';
import 'package:recase/recase.dart';

class ProviderGenerationConfiguration extends GenerationConfiguration {
  ProviderGenerationConfiguration();

  Set<String> registeredModels = {};

  @override
  Future<void> setUpConfiguration() async {
    logger = Logger('Provider');
    logger.info(
        'Thanks for trying our state management configuration that is now in Beta!\nIf you run into any issues please feel free to post it in Github or in our Discord!');
    fileStructureStrategy = ProviderFileStructureStrategy(
        pbProject.projectAbsPath, pageWriter, pbProject);
    registerMiddleware(ProviderMiddleware(generationManager));
    logger.info('Setting up the directories');
    await fileStructureStrategy.setUpDirectories();
  }

  @override
  Future<void> generateProject(PBProject pb_project) async {
    await super.generateProject(pb_project);
    if (pageWriter is PBFlutterWriter) {
      Set imports = <String>{'import \'package:provider/provider.dart\';'};
      imports.addAll(registeredModels
          .map((e) => 'import \'models/${e.snakeCase}.dart\';')
          .toList());

      (pageWriter as PBFlutterWriter).rewriteMainFunction(
        fileStructureStrategy.GENERATED_PROJECT_PATH + 'lib/main.dart',
        _generateMainFunction(),
        imports: imports,
      );
    }
  }

  ///This is going to modify the [PBIntermediateNode] in order to affect the structural patterns or file structure produced.
  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    var it = middlewares.iterator;
    while (it.moveNext()) {
      node = await it.current.applyMiddleware(node);
      if (it.current is ProviderMiddleware &&
          node is PBSharedInstanceIntermediateNode) {
        registeredModels.add(ImportHelper.getName(node.functionCallName));
      }
    }
    return node;
  }

  String _generateMainFunction() {
    return '''
    runApp(MyApp());
    ''';
  }
}
