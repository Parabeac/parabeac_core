import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/flutter_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:recase/recase.dart';

class StatefulMiddleware extends Middleware {
  StatefulMiddleware(PBGenerationManager generationManager)
      : super(generationManager);

  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    var fileStrategy = node.currentContext.project.fileStructureStrategy
        as FlutterFileStructureStrategy;

    if (node is PBSharedInstanceIntermediateNode) {
      addImportToCache(node.SYMBOL_ID, getImportPath(node, fileStrategy));
      return node;
    }
    var states = <PBIntermediateNode>[node];
    var parentDirectory = getName(node.name).snakeCase;

    node?.auxiliaryData?.stateGraph?.states?.forEach((state) {
      states.add(state.variation.node);
    });

    states.forEach((element) async {
      element.currentContext.tree.data = node.managerData;
      await fileStrategy.generatePage(
        generationManager.generate(element),
        '$parentDirectory/${element.name.snakeCase}',
        args: 'VIEW',
      );
    });

    return node;
  }

  String getImportPath(PBSharedInstanceIntermediateNode node, fileStrategy) {
    var symbolMaster =
        PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID);
    return fileStrategy.GENERATED_PROJECT_PATH +
        fileStrategy.RELATIVE_VIEW_PATH +
        '${getName(symbolMaster.name).snakeCase}/${node.functionCallName.snakeCase}.dart';
  }
}
