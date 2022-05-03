import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/state_management_middleware.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/utils/middleware_utils.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/provider_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/provider_generation_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/element_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:recase/recase.dart';
import 'package:parabeac_core/generation/generators/value_objects/generator_adapter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:path/path.dart' as p;

import '../../pb_flutter_generator.dart';

class ProviderMiddleware extends StateManagementMiddleware {
  final PACKAGE_NAME = 'provider';
  final PACKAGE_VERSION = '^4.3.2+3';

  ProviderMiddleware(PBGenerationManager generationManager,
      ProviderGenerationConfiguration configuration)
      : super(generationManager, configuration);

  String getImportPath(PBSharedInstanceIntermediateNode node,
      ProviderFileStructureStrategy fileStrategy,
      {bool generateModelPath = true}) {
    var symbolMaster =
        PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID);

    var import = generateModelPath
        ? p.join(fileStrategy.RELATIVE_MODEL_PATH,
            ImportHelper.getName(symbolMaster.name).snakeCase)
        : p.join(
            FileStructureStrategy.RELATIVE_VIEW_PATH,
            ImportHelper.getName(symbolMaster.name).snakeCase,
            node.functionCallName.snakeCase);
    return p.join(fileStrategy.GENERATED_PROJECT_PATH, import);
  }

  @override
  Future<PBIntermediateNode> handleStatefulNode(
      PBIntermediateNode node, PBContext context) {
    String watcherName;
    var managerData = context.managerData;
    var fileStrategy =
        configuration.fileStructureStrategy as ProviderFileStructureStrategy;
    var elementStorage = ElementStorage();

    if (node is PBSharedInstanceIntermediateNode) {
      context.project.genProjectData
          .addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
      managerData.addImport(FlutterImport('provider.dart', 'provider'));
      watcherName = getVariableName(node.name.snakeCase + '_notifier');

      /// Get the default node's tree in order to add to dependent of the current tree.
      ///
      /// This ensures we have the correct model imports when generating the tree.
      var defaultNodeTreeUUID = elementStorage
          .elementToTree[stmgHelper.getStateGraphOfNode(node).defaultNode.UUID];
      var defaultNodeTree = elementStorage.treeUUIDs[defaultNodeTreeUUID];

      context.tree.addDependent(defaultNodeTree);

      PBGenCache().appendToCache(node.SYMBOL_ID,
          getImportPath(node, fileStrategy, generateModelPath: false));

      if (node.generator is! StringGeneratorAdapter) {
        var modelName = ImportHelper.getName(node.functionCallName).pascalCase;
        var providerWidget = '''
        ChangeNotifierProvider(
          create: (context) =>
              $modelName(), 
          child: LayoutBuilder(
            builder: (context, constraints) {
              var widget = ${MiddlewareUtils.generateVariableBody(node, context)};
              
              context
                  .read<$modelName>()
                  .setCurrentWidget(
                      widget); // Setting active state

              return GestureDetector(
                onTap: () => context.read<
                    $modelName>().onGesture(),
                child: Consumer<$modelName>(
                  builder: (context, ${modelName.toLowerCase()}, child) => ${modelName.toLowerCase()}.currentWidget
                ),
              );
            },
          ),
        )
        ''';
        node.generator = StringGeneratorAdapter(providerWidget);
      }

      return Future.value(node);
    }
    watcherName = getNameOfNode(node);

    var parentDirectory = WriteSymbolCommand.DEFAULT_SYMBOL_PATH +
        ImportHelper.getName(node.name).snakeCase;

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
      WriteSymbolCommand(
        context.tree.UUID,
        node.name.snakeCase,
        generationManager.generate(node, context),
        symbolPath: parentDirectory,
      ),
    ].forEach(fileStrategy.commandCreated);

    (configuration as ProviderGenerationConfiguration)
        .registeredModels
        .add(watcherName);

    // Generate node's states' view pages
    var nodeStateGraph = stmgHelper.getStateGraphOfNode(node);
    nodeStateGraph?.states?.forEach((state) {
      var treeUUID = elementStorage.elementToTree[state.UUID];
      var tree = elementStorage.treeUUIDs[treeUUID];
      // generate imports for state view
      var data = PBGenerationViewData()
        ..addImport(FlutterImport('material.dart', 'flutter'));
      tree.generationViewData.importsList.forEach(data.addImport);
      tree.context.generationManager =
          PBFlutterGenerator(ImportHelper(), data: data);

      fileStrategy.commandCreated(WriteSymbolCommand(
        tree.UUID,
        state.name.snakeCase,
        tree.context.generationManager.generate(state, tree.context),
        symbolPath: parentDirectory,
      ));
    });

    return Future.value(null);
  }
}
