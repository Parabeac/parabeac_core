import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/export_platform_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_screen_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_platform_orientation_generation_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';
import 'package:recase/recase.dart';

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
    } else if (tree.rootNode.auxiliaryData.stateGraph.states.isEmpty) {
      // TODO: Find a more optimal way to exclude state management nodes
      command = WriteSymbolCommand(
        tree.UUID,
        tree.identifier,
        generationManager.generate(tree.rootNode, context),
        relativePath: tree.name,
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

    while (iter.moveNext()) {
      _importProcessor.getFormattedImports(
        iter.current.UUID,
        importMapper: (import) => addImport(FlutterImport(import, packageName)),
      );
    }
  }
}
