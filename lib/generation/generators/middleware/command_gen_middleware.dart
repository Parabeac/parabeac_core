import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/export_platform_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_screen_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_platform_orientation_generation_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/element_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_state_management_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/directed_state_graph.dart';
import 'package:recase/recase.dart';
import 'package:path/path.dart' as p;

class CommandGenMiddleware extends Middleware
    with PBPlatformOrientationGeneration {
  final String packageName;
  final ImportHelper _importProcessor;
  PBPlatformOrientationLinkerService poLinker;

  CommandGenMiddleware(
    PBGenerationManager generationManager,
    GenerationConfiguration configuration,
    this._importProcessor,
    this.packageName,
  ) : super(generationManager, configuration) {
    poLinker = configuration.poLinker;
  }

  @override
  Future<PBIntermediateTree> applyMiddleware(
      PBIntermediateTree tree, PBContext context) {
    if (tree == null) {
      return Future.value(tree);
    }

    var command;
    _addDependencyImports(tree, packageName, context);
    if (poLinker.screenHasMultiplePlatforms(tree.identifier)) {
      getPlatformOrientationName(tree.rootNode, context);

      command = ExportPlatformCommand(
        tree.UUID,
        context.tree.generationViewData.platform,
        tree.identifier,
        tree.rootNode.name.snakeCase,
        generationManager.generate(tree.rootNode, context),
      );
    } else if (tree.isScreen()) {
      command = WriteScreenCommand(
        tree.UUID,
        tree.identifier,
        tree.name,
        generationManager.generate(tree.rootNode, context),
      );
    } else if (PBStateManagementHelper()
            .getStateGraphOfNode(tree.rootNode)
            ?.states
            ?.isEmpty ??
        true) {
      // TODO: Find a more optimal way to exclude state management nodes
      var relativePath = tree.name;
      if (tree.rootNode is PBSharedMasterNode) {
        var componentSetName =
            (tree.rootNode as PBSharedMasterNode).componentSetName;
        relativePath = componentSetName != null
            ? p.join(relativePath, componentSetName.snakeCase)
            : relativePath;
      }

      command = WriteSymbolCommand(
        tree.UUID,
        tree.identifier,
        generationManager.generate(tree.rootNode, context),
        symbolPath:
            p.join(WriteSymbolCommand.DEFAULT_SYMBOL_PATH, relativePath),
      );
    }
    if (command != null) {
      configuration.fileStructureStrategy.commandCreated(command);
    }
    return Future.value(tree);
  }

  /// Method that traverses `tree`'s dependencies and looks for an import path from
  /// [ImportHelper].
  ///
  /// If an import path is found, it will be added to the `tree`'s data. The package format
  /// for imports is going to be enforced, therefore, [packageName] is going to be
  /// a required parameter.
  void _addDependencyImports(
      PBIntermediateTree tree, String packageName, PBContext context) {
    var iter = tree.dependentsOn;
    var addImport = context.managerData.addImport;

    /// Check if [tree] has states. If states are present, we need to check
    /// each of the states for dependencies.
    var smHelper = PBStateManagementHelper();
    var stateGraph = smHelper.getStateGraphOfNode(tree.rootNode);
    if (stateGraph != null && tree.rootNode == stateGraph.defaultNode) {
      _checkStateGraphImports(stateGraph, packageName);
    }

    while (iter.moveNext()) {
      _importProcessor.getFormattedImports(
        iter.current.UUID,
        importMapper: (import) => addImport(FlutterImport(import, packageName)),
      );
    }
  }

  void _checkStateGraphImports(DirectedStateGraph graph, String packageName) {
    var elementStorage = ElementStorage();
    graph.states.forEach((state) {
      // Get state's graph
      var stateTreeUUID = elementStorage.elementToTree[state.UUID];
      var stateTree = elementStorage.treeUUIDs[stateTreeUUID];

      _addDependencyImports(stateTree, packageName, stateTree.context);
    });
  }
}
