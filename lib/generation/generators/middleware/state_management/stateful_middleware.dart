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
    var manager = generationManager;
    var fileStrategy = manager.fileStrategy as FlutterFileStructureStrategy;

    if (node is PBSharedInstanceIntermediateNode) {
      manager.addAllMethodVariable(await _getVariables(node));
      print('Hello Symbol Instance');
      node.generator = StringGeneratorAdapter(await _generateInstance(node));
      return node;
    }
    var states = <PBIntermediateNode>[node];
    var parentDirectory = node.name.snakeCase;

    await node?.auxiliaryData?.stateGraph?.states?.forEach((state) {
      states.add(state.variation.node);
    });

    var variables = await _getVariables(node);

    await states.forEach((element) async {
      await fileStrategy.generatePage(
        await manager.generate(element),
        '${parentDirectory}/${element.name.snakeCase}',
        args: 'VIEW',
      );
    });
    manager.addAllGlobalVariable(variables);
    node.generator = StringGeneratorAdapter(node.name.snakeCase);

    return node;
  }

  Future<List<PBVariable>> _getVariables(PBIntermediateNode node) async {
    List<PBVariable> variables = [];
    var symbolMaster;
    if (node is PBSharedInstanceIntermediateNode) {
      symbolMaster =
          PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID);
    } else if (node is PBSharedMasterNode) {
      symbolMaster = node;
    }
    var states = <PBIntermediateNode>[symbolMaster];
    await symbolMaster?.auxiliaryData?.stateGraph?.states?.forEach((state) {
      states.add(state.variation.node);
    });
    await states.forEach((state) {
      var tempNode = state;
      var tempVar = PBVariable(
        tempNode.name.snakeCase,
        'final ',
        true,
        tempNode.name == symbolMaster.name
            ? '${tempNode.name.pascalCase}()'
            : null,
      );
      variables.add(tempVar);
    });
    return variables;
  }

  String _generateInstance(PBIntermediateNode node) {
    return node.name.snakeCase;
  }
}
