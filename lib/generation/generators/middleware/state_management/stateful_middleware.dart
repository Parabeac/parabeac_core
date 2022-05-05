import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/state_management_middleware.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/element_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:recase/recase.dart';
import 'package:path/path.dart' as p;

import '../../import_generator.dart';

class StatefulMiddleware extends StateManagementMiddleware {
  StatefulMiddleware(PBGenerationManager generationManager,
      GenerationConfiguration configuration)
      : super(generationManager, configuration);

  String getImportPath(PBSharedInstanceIntermediateNode node,
      FileStructureStrategy fileStrategy) {
    var symbolMaster =
        PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID);
    var path = p.join(
        fileStrategy.GENERATED_PROJECT_PATH,
        FileStructureStrategy.RELATIVE_WIDGET_PATH,
        ImportHelper.getName(symbolMaster.name).snakeCase,
        node.functionCallName.snakeCase);
    return path;
  }

  @override
  Future<PBIntermediateNode> handleStatefulNode(
      PBIntermediateNode node, PBContext context) {
    var fileStrategy = configuration.fileStructureStrategy;
    var elementStorage = ElementStorage();

    if (node is PBSharedInstanceIntermediateNode) {
      /// Get the default node's tree in order to add to dependent of the current tree.
      ///
      /// This ensures we have the correct model imports when generating the tree.
      var defaultNodeTreeUUID = elementStorage
          .elementToTree[stmgHelper.getStateGraphOfNode(node).defaultNode.UUID];
      var defaultNodeTree = elementStorage.treeUUIDs[defaultNodeTreeUUID];

      context.tree.addDependent(defaultNodeTree);
      return Future.value(node);
    }

    fileStrategy.commandCreated(WriteSymbolCommand(context.tree.UUID,
        node.name.snakeCase, generationManager.generate(node, context)));

    // Generate node's states' view pages
    //TODO: Find a way to abstract the process below in order to be used by any middleware
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
        symbolPath: WriteSymbolCommand.DEFAULT_SYMBOL_PATH +
            ImportHelper.getName(node.name).snakeCase,
      ));
    });

    return Future.value(null);
  }
}
