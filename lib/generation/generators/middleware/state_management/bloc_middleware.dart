import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/flutter_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generator_adapter.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/bloc_state_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:recase/recase.dart';
import '../../pb_generation_manager.dart';
import '../middleware.dart';

class BLoCMiddleware extends Middleware {
  final PACKAGE_NAME = 'flutter_bloc';
  final PACKAGE_VERSION = '^6.1.1';

  BLoCMiddleware(PBGenerationManager generationManager)
      : super(generationManager);

  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    var managerData = node.managerData;
    node.currentContext.project.genProjectData
        .addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
    managerData.addImport('package:flutter_bloc/flutter_bloc.dart');
    var fileStrategy = node.currentContext.project.fileStructureStrategy
        as FlutterFileStructureStrategy;

    /// Incase of SymbolInstance
    if (node is PBSharedInstanceIntermediateNode) {
      var generalStateName = node.functionCallName
          .substring(0, node.functionCallName.lastIndexOf('/'));

      var globalVariableName = getVariableName(node.name.snakeCase);
      managerData.addGlobalVariable(PBVariable(globalVariableName, 'var ', true,
          '${generalStateName.pascalCase}Bloc()'));

      addImportToCache(node.SYMBOL_ID, getImportPath(node, fileStrategy));

      managerData.addToDispose('${globalVariableName}.close()');
      if (node.generator is! StringGeneratorAdapter) {
        node.generator = StringGeneratorAdapter('''
      BlocBuilder<${generalStateName.pascalCase}Bloc, ${generalStateName.pascalCase}State>(
        cubit: ${globalVariableName},
        builder: (context, state) => state.widget  
      )
      ''');
      }
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
      element.currentContext.treeRoot.data = node.managerData;
      element.generator.templateStrategy = BLoCStateTemplateStrategy(
        isFirst: isFirst,
        abstractClassName: parentState,
      );
      stateBuffer.write(generationManager.generate(element));
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
    managerData.addImport('package:meta/meta.dart');
    await fileStrategy.generatePage(
      _createBlocPage(
        parentState,
        node.name,
      ),
      '${parentDirectory}/${generalName}_bloc',
      args: 'VIEW',
    );

    return node;
  }

  String _createBlocPage(String name, String initialStateName) {
    var pascalName = name.pascalCase;
    var snakeName = name.snakeCase;
    return '''
    ${generationManager.generateImports()}

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

  String getImportPath(PBSharedInstanceIntermediateNode node, fileStrategy) {
    var generalStateName = node.functionCallName
        .substring(0, node.functionCallName.lastIndexOf('/'));
    var symbolMaster =
        PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID);
    return fileStrategy.GENERATED_PROJECT_PATH +
        fileStrategy.RELATIVE_VIEW_PATH +
        '${generalStateName.snakeCase}_bloc/${getName(symbolMaster.name).snakeCase}_bloc.dart';
  }
}
