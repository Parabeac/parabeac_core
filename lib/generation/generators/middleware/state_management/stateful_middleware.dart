import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/flutter_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generator_adapter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:recase/recase.dart';

import '../../pb_variable.dart';

class StatefulMiddleware extends Middleware {
  StatefulMiddleware(PBGenerationManager generationManager)
      : super(generationManager);

  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    var managerData = node.managerData;
    var fileStrategy = node.currentContext.project.fileStructureStrategy
        as FlutterFileStructureStrategy;

    if (node is PBSharedInstanceIntermediateNode) {
      managerData.addGlobalVariable(await _getVariables(node));
      node.generator = StringGeneratorAdapter(node.name.snakeCase);
      addImportToCache(node.SYMBOL_ID, getImportPath(node, fileStrategy));
      return node;
    }
    var states = <PBIntermediateNode>[node];
    var parentDirectory = getName(node.name).snakeCase;

    await node?.auxiliaryData?.stateGraph?.states?.forEach((state) {
      states.add(state.variation.node);
    });

    await states.forEach((element) async {
      await fileStrategy.generatePage(
        await generationManager.generate(element),
        '${parentDirectory}/${element.name.snakeCase}',
        args: 'VIEW',
      );
    });

    return node;
  }

  Future<PBVariable> _getVariables(
      PBSharedInstanceIntermediateNode node) async {
    var symbolMaster =
        PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID);

    var tempVar = PBVariable(
      node.name.snakeCase,
      'var ',
      true,
      node.functionCallName == symbolMaster.name
          ? '${symbolMaster.name.pascalCase}()'
          : null,
    );

    return tempVar;
  }

  String getImportPath(PBSharedInstanceIntermediateNode node, fileStrategy) {
    var symbolMaster =
        PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID);
    return fileStrategy.GENERATED_PROJECT_PATH +
        fileStrategy.RELATIVE_VIEW_PATH +
        '${getName(symbolMaster.name).snakeCase}/${node.functionCallName.snakeCase}.dart';
  }
}
