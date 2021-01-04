import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/provider_management.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/stateful_management.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/value_objects/pb_file_structure_strategy.dart';
`import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:quick_log/quick_log.dart';
import 'package:recase/recase.dart';

abstract class GenerationConfiguration {
  FileStructureStrategy _fileStructureStrategy;
  FileStructureStrategy get fileStructureStrategy {
    if (_fileStructureStrategy == null) {
      throw Exception(
          'Do not forget to initialize the fileStructure by calling `initializeFileStructure()`');
    }
    return _fileStructureStrategy;
  }

  Logger logger;

  final Set<Middleware> _middleware = {};

  ///The tree that contains the node for all the pages.
  PBIntermediateTree _intermediateTree;

  ///The manager in charge of the independent [PBGenerator]s by providing an interface for adding imports, global variables, etc.
  ///
  ///The default [PBGenerationManager] will be [PBFlutterGenerator]
  PBGenerationManager _generationManager;

  GenerationConfiguration() {
    logger = Logger(runtimeType.toString());
    _generationManager = PBFlutterGenerator(null);
  }

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
    _intermediateTree = projectIntermediateTree;
    await setUpConfiguration();
    _intermediateTree.groups.forEach((group) {
      for (var item in group.items) {
        var fileName = item.node?.name?.snakeCase ?? 'no_name_found';
        _commitImports(item.node, group.name.snakeCase, fileName);
        _generateNode(item.node, fileName);
        _commitDependencies(
            projectIntermediateTree.projectName + '/pubspec.yalm');
      }
    });
  }

  void registerMiddleware(Middleware middleware) {
    if (middleware != null) {
      _middleware.add(middleware);
    }
  }

  Future<void> setUpConfiguration() async {
    _fileStructureStrategy = FlutterFileStructureStrategy(
        _intermediateTree.projectAbsPath, PBFlutterWriter(), _intermediateTree);
    _generationManager.fileStrategy = _fileStructureStrategy;
    logger.info('Settting up the directories');
    await _fileStructureStrategy.setUpDirectories();
  }

  void _commitImports(
      PBIntermediateNode node, String directoryName, String fileName) {
    var screenFilePath =
        '${_intermediateTree.projectName}/lib/screens/${directoryName}/${fileName.snakeCase}.dart';
    var viewFilePath =
        '${_intermediateTree.projectName}/lib/views/${directoryName}/${fileName.snakeCase}.g.dart';
    ImportHelper.findImports(
        node, node is InheritedScaffold ? screenFilePath : viewFilePath);
  }

  void _commitDependencies(String projectName) {
    var writer = fileStructureStrategy.pageWriter;
    if (writer is PBFlutterWriter) {
      writer.submitDependencies(projectName + '/pubspec.yaml');
    }
  }

  Future<void> _generateNode(PBIntermediateNode node, String filename) async =>
      _fileStructureStrategy.generatePage(
          _generationManager.generate(await applyMiddleware(node)), filename,
          args: node is InheritedScaffold ? 'SCREEN' : 'VIEW');
}

class ProviderGenerationConfiguration extends GenerationConfiguration {
  ProviderMiddleware middleware;
  ProviderGenerationConfiguration() {
    registerMiddleware(ProviderMiddleware());
  }

  @override
  Future<void> setUpConfiguration() async {
    _fileStructureStrategy = ProviderFileStructureStrategy(
        _intermediateTree.projectAbsPath, PBFlutterWriter(), _intermediateTree);
    logger.info('Settting up the directories');
    await _fileStructureStrategy.setUpDirectories();
  }
}

class StatefulGenerationConfiguration extends GenerationConfiguration {
  StatefulGenerationConfiguration() {
    registerMiddleware(StatefulMiddleware());
  }
}
