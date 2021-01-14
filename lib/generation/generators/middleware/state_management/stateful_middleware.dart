import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/flutter_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generator_adapter.dart';
import 'package:parabeac_core/input/sketch/entities/layers/symbol_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:recase/recase.dart';

import '../../pb_variable.dart';

class StatefulMiddleware extends Middleware {
  StatefulMiddleware(PBGenerationManager generationManager)
      : super(generationManager);

  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    if (node is SymbolInstance) {
      print('Hello Symbol Instance');
    }
    var states = <PBIntermediateNode>[node];
    var manager = generationManager;
    var fileStrategy = manager.fileStrategy as FlutterFileStructureStrategy;
    var parentDirectory = node.name.snakeCase;

    await node?.auxiliaryData?.stateGraph?.states?.forEach((state) {
      states.add(state.variation.node);
    });

    var variables = <PBVariable>[];

    await states.forEach((element) async {
      var watcher = PBVariable(
        element.name.camelCase,
        'final ',
        true,
        element.name == node.name ? '${element.name.pascalCase}()' : null,
      );
      variables.add(watcher);
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
}
