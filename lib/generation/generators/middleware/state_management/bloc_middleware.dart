import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/flutter_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generator_adapter.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/bloc_state_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:recase/recase.dart';
import '../../pb_generation_manager.dart';
import '../middleware.dart';

class BLoCMiddleware extends Middleware {
  final PACKAGE_NAME = 'bloc';
  final PACKAGE_VERSION = '^6.1.1';

  BLoCMiddleware(PBGenerationManager generationManager)
      : super(generationManager);

  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    var manager = node.treeManager;
    manager.addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
    manager.addImport('package:bloc/bloc.dart');
    var fileStrategy = manager.fileStrategy as FlutterFileStructureStrategy;

    /// Incase of SymbolInstance
    if (node is PBSharedInstanceIntermediateNode) {
      var variableName = node.functionCallName.snakeCase;
      manager.addGlobalVariable(PBVariable(variableName, 'final ', true, null));
      node.generator = StringGeneratorAdapter(variableName);
      return node;
    }
    var parentState = getNameOfNode(node);
    var generalName = parentState.snakeCase;
    var parentDirectory = generalName + '_bloc';
    var states = <PBIntermediateNode>[node];

    var stateBuffer = StringBuffer();

    await node?.auxiliaryData?.stateGraph?.states?.forEach((state) {
      states.add(state.variation.node);
    });

    var isFirst = true;
    await states.forEach((element) {
      element.generator.templateStrategy = BLoCStateTemplateStrategy(
        isFirst: isFirst,
        abstractClassName: parentState,
      );
      stateBuffer.write(manager.generate(element));
      isFirst = false;
    });

    /// Creates state page
    await fileStrategy.generatePage(
      stateBuffer.toString(),
      '${parentDirectory}/${generalName}_state',
      args: 'VIEW',
    );

    /// Creates event page
    await fileStrategy.generatePage(
      _createEventPage(parentState),
      '${parentDirectory}/${generalName}_event',
      args: 'VIEW',
    );

    /// Creates bloc page
    await fileStrategy.generatePage(
      _createBlocPage(parentState, node.name),
      '${parentDirectory}/${generalName}_bloc',
      args: 'VIEW',
    );

    return node;
  }

  String _createBlocPage(String name, String initialStateName) {
    var pascalName = name.pascalCase;
    var snakeName = name.snakeCase;
    return '''
    import 'dart:async';

    import 'package:bloc/bloc.dart';
    import 'package:meta/meta.dart';
    import 'package:flutter/material.dart';

    part '${snakeName}_event.dart';
    part '${snakeName}_state.dart';

    class ${pascalName}Bloc extends Bloc<${pascalName}Event, ${pascalName}State> {
      ${pascalName}Bloc() : super(${initialStateName.pascalCase}State());

      @override
      Stream<${pascalName}State> mapEventToState(
        ${pascalName}Event event,
      ) async* {
        // TODO: implement mapEventToState
      }
    }
    ''';
  }

  String _createEventPage(String name) {
    var pascalName = name.pascalCase;
    return '''
    part of '${name.snakeCase}_bloc.dart';

    @immutable
    abstract class ${pascalName}Event {}
    ''';
  }
}
