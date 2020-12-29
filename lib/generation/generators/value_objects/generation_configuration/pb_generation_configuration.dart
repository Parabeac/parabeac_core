import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/flutter_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/pb_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:quick_log/quick_log.dart';
import 'package:recase/recase.dart';

abstract class GenerationConfiguration {
  FileStructureStrategy fileStructureStrategy;

  Logger logger;

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

  ///This is going to modify the [PBIntermediateNode] in order to affect the structural patterns or file structure produced.
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    return Future.value(node);
  }

  ///generates the Project based on the [projectIntermediateTree]
  Future<void> generateProject(
      PBIntermediateTree projectIntermediateTree) async {
    intermediateTree = projectIntermediateTree;
    await setUpConfiguration();
    intermediateTree.groups.forEach((group) {
      for (var item in group.items) {
        var fileName = item.node?.name?.snakeCase ?? 'no_name_found';
        _commitImports(item.node, group.name.snakeCase, fileName);
        _generateNode(item.node, fileName);
        _commitDependencies(
            projectIntermediateTree.projectName + '/pubspec.yalm');
      }
    });
  }

  Future<void> setUpConfiguration() async {
    fileStructureStrategy = FlutterFileStructureStrategy(
        intermediateTree.projectAbsPath, PBFlutterWriter(), intermediateTree);
    _generationManager.fileStrategy = fileStructureStrategy;
    logger.info('Settting up the directories');
    await fileStructureStrategy.setUpDirectories();
  }

  void _commitImports(
      PBIntermediateNode node, String directoryName, String fileName) {
    var screenFilePath =
        '${intermediateTree.projectName}/lib/screens/${directoryName}/${fileName.snakeCase}.dart';
    var viewFilePath =
        '${intermediateTree.projectName}/lib/views/${directoryName}/${fileName.snakeCase}.g.dart';
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
      fileStructureStrategy.generatePage(
          _generationManager.generate(await applyMiddleware(node)), filename,
          args: node is InheritedScaffold ? 'SCREEN' : 'VIEW');
}
