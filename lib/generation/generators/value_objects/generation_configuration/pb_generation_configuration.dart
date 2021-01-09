import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/flutter_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/pb_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:quick_log/quick_log.dart';
import 'package:recase/recase.dart';

abstract class GenerationConfiguration {
  FileStructureStrategy fileStructureStrategy;

  Logger logger;

  final Set<Middleware> _middleware = {};

  ///The tree that contains the node for all the pages.
  PBIntermediateTree intermediateTree;

  ///The manager in charge of the independent [PBGenerator]s by providing an interface for adding imports, global variables, etc.
  ///
  ///The default [PBGenerationManager] will be [PBFlutterGenerator]
  PBGenerationManager _generationManager;

  GenerationConfiguration() {
    logger = Logger(runtimeType.toString());
    _generationManager = PBFlutterGenerator(null);
  }

  PBGenerationManager get generationManager => _generationManager;

  ///This is going to modify the [PBIntermediateNode] in order to affect the structural patterns or file structure produced.
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    var it = _middleware.iterator;
    while (it.moveNext()) {
      node = await it.current.applyMiddleware(node);
    }
    return node;
  }

  ///generates the Project based on the [projectIntermediateTree]
  Future<void> generateProject(
      PBIntermediateTree projectIntermediateTree) async {
    intermediateTree = projectIntermediateTree;

    await setUpConfiguration();
    await intermediateTree.groups.forEach((group) async {
      await group.items.forEach((item) async {
        _generationManager = PBFlutterGenerator(fileStructureStrategy);
        _generationManager.rootType = item.node.runtimeType;

        var fileName = item.node?.name?.snakeCase ?? 'no_name_found';
        _commitImports(item.node, group.name.snakeCase, fileName);
        await _generateNode(item.node, '${group.name.snakeCase}/${fileName}');
      });
    });
    await _commitDependencies(projectIntermediateTree.projectName);
  }

  void registerMiddleware(Middleware middleware) {
    if (middleware != null) {
      _middleware.add(middleware);
    }
  }

  Future<void> setUpConfiguration() async {
    fileStructureStrategy = FlutterFileStructureStrategy(
        intermediateTree.projectAbsPath, PBFlutterWriter(), intermediateTree);
    _generationManager.fileStrategy = fileStructureStrategy;
    logger.info('Setting up the directories');
    await fileStructureStrategy.setUpDirectories();
  }

  void _commitImports(
      PBIntermediateNode node, String directoryName, String fileName) {
    var screenFilePath =
        '${intermediateTree.projectName}/lib/screens/${directoryName}/${fileName.snakeCase}.dart';
    var viewFilePath =
        '${intermediateTree.projectName}/lib/views/${directoryName}/${fileName.snakeCase}.g.dart';
    var imports = ImportHelper.findImports(
        node, node is InheritedScaffold ? screenFilePath : viewFilePath);
    imports.forEach((import) {
      _generationManager.addImport(import);
    });
  }

  Future<void> _commitDependencies(String projectName) async {
    var writer = PBFlutterWriter();
    if (writer is PBFlutterWriter) {
      writer.submitDependencies(projectName + '/pubspec.yaml');
    }
  }

  Future<void> _generateNode(PBIntermediateNode node, String filename) async {
    if (node?.auxiliaryData?.stateGraph?.states?.isNotEmpty ?? false) {
      await applyMiddleware(node);
    } else {
      await _generationManager.fileStrategy.generatePage(
          await _generationManager.generate(node), filename,
          args: node is InheritedScaffold ? 'SCREEN' : 'VIEW');
    }
  }
}
