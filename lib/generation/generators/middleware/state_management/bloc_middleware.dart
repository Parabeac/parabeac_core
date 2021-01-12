import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/flutter_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generator_adapter.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/bloc_state_template_strategy.dart';
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
    if (node?.auxiliaryData?.stateGraph?.states?.isNotEmpty ?? false) {
      var parentState = getNameOfNode(node);
      var parentDirectory = parentState.snakeCase;
      var states = <PBIntermediateNode>[node];
      var manager = generationManager;
      manager.addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
      manager.addImport('package:bloc/bloc.dart');
      var fileStrategy = manager.fileStrategy as FlutterFileStructureStrategy;

      var stateBuffer = StringBuffer();

      await node?.auxiliaryData?.stateGraph?.states?.forEach((state) {
        states.add(state.variation.node);
      });

      var isFirst = true;
      await states.forEach((element) {
        //TODO: create another template strategy
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
        '${parentDirectory}/${parentDirectory}_state',
        args: 'VIEW',
      );

      /// Creates event page
      await fileStrategy.generatePage(
        _createEventPage(parentState),
        '${parentDirectory}/${parentDirectory}_event',
        args: 'VIEW',
      );

      /// Creates bloc page
      await fileStrategy.generatePage(
        _createBlocPage(parentState, node.name),
        '${parentDirectory}/${parentDirectory}_bloc',
        args: 'VIEW',
      );

      node.generator = StringGeneratorAdapter(node.name.snakeCase);
    }

    return node;
  }

  String _createBlocPage(String name, String initialState) {
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
      ${pascalName}Bloc() : super(${initialState.pascalCase}State());

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
