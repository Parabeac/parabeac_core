import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/state_management_middleware.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/utils/middleware_utils.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/riverpod_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/riverpod_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generator_adapter.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/stateless_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/element_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import '../../pb_flutter_generator.dart';
import '../../pb_generation_manager.dart';
import '../../pb_variable.dart';
import 'package:recase/recase.dart';

class RiverpodMiddleware extends StateManagementMiddleware {
  final PACKAGE_NAME = 'flutter_riverpod';
  final PACKAGE_VERSION = '^0.12.1';

  RiverpodMiddleware(PBGenerationManager generationManager,
      RiverpodGenerationConfiguration configuration)
      : super(generationManager, configuration);

  String getConsumer(String name, String pointTo) {
    return '''
    Consumer(
      builder: (context, watch, child) {
        final $name = watch(${name}_provider); 
        return $name.$pointTo;
      },
    )
    ''';
  }

  String getImportPath(PBSharedInstanceIntermediateNode node, fileStrategy) {
    var symbolMaster =
        PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID);
    return fileStrategy.GENERATED_PROJECT_PATH +
        fileStrategy.RELATIVE_MODEL_PATH +
        '${ImportHelper.getName(symbolMaster.name).snakeCase}.dart';
  }

  @override
  Future<PBIntermediateNode> handleStatefulNode(
      PBIntermediateNode node, PBContext context) {
    String watcherName;
    var managerData = context.managerData;
    var fileStrategy =
        configuration.fileStructureStrategy as RiverpodFileStructureStrategy;

    if (node is PBSharedInstanceIntermediateNode) {
      context.project.genProjectData
          .addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
      managerData.addImport(
          FlutterImport('flutter_riverpod.dart', 'flutter_riverpod'));
      watcherName = getVariableName(node.functionCallName.snakeCase);
      var watcher = PBVariable(watcherName + '_provider', 'final ', true,
          'ChangeNotifierProvider((ref) => ${ImportHelper.getName(node.functionCallName).pascalCase}())');

      if (context.tree.rootNode.generator.templateStrategy
          is StatelessTemplateStrategy) {
        managerData.addGlobalVariable(watcher);
      } else {
        managerData.addMethodVariable(watcher);
      }

      addImportToCache(node.SYMBOL_ID, getImportPath(node, fileStrategy));

      if (node.generator is! StringGeneratorAdapter) {
        node.generator = StringGeneratorAdapter(getConsumer(
            watcherName, 'currentWidget')); // node.functionCallName.camelCase
      }

      return Future.value(node);
    }
    watcherName = getNameOfNode(node);

    var parentDirectory = ImportHelper.getName(node.name).snakeCase;

    // Generate model's imports
    var modelGenerator = PBFlutterGenerator(ImportHelper(),
        data: PBGenerationViewData()
          ..addImport(FlutterImport('material.dart', 'flutter')));
    // Write model class for current node
    var code = MiddlewareUtils.generateModelChangeNotifier(
        watcherName, modelGenerator, node, context);

    [
      /// This generated the `changeNotifier` that goes under the [fileStrategy.RELATIVE_MODEL_PATH]
      WriteSymbolCommand(
        context.tree.UUID,
        parentDirectory,
        code,
        symbolPath: fileStrategy.RELATIVE_MODEL_PATH,
        ownership: FileOwnership.DEV,
      ),
      // Generate default node's view page
      WriteSymbolCommand(context.tree.UUID, node.name.snakeCase,
          generationManager.generate(node, context),
          relativePath: parentDirectory),
    ].forEach(fileStrategy.commandCreated);

    var stateGraph = stmgHelper.getStateGraphOfNode(node);

    var elementStorage = ElementStorage();
    // Generate node's states' view pages
    stateGraph?.states?.forEach((state) {
      var treeUUID = elementStorage.elementToTree[node];
      var tree = elementStorage.treeUUIDs[treeUUID];
      fileStrategy.commandCreated(WriteSymbolCommand(
        tree.UUID,
        // state.variation.node.currentContext.tree.UUID,
        state.name.snakeCase,
        generationManager.generate(state, tree.context),
        relativePath: parentDirectory,
      ));
    });

    return Future.value(null);
  }
}
