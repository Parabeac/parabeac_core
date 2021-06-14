import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/state_management_middleware.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/bloc_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generator_adapter.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/bloc_state_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:recase/recase.dart';
import '../../pb_generation_manager.dart';
import 'package:path/path.dart' as p;

class BLoCMiddleware extends StateManagementMiddleware {
  final PACKAGE_NAME = 'flutter_bloc';
  final PACKAGE_VERSION = '^6.1.1';

  BLoCMiddleware(PBGenerationManager generationManager,
      GenerationConfiguration configuration)
      : super(generationManager, configuration);

  String _createBlocPage(String name, String initialStateName) {
    var pascalName = name.pascalCase;
    var snakeName = name.snakeCase;
    return '''
    ${generationManager.generateImports()}

    part '${snakeName}_state.dart';

    class ${pascalName}Cubit extends Cubit<${pascalName}State> {
      ${pascalName}Cubit() : super(${initialStateName.pascalCase}State());

      void onGesture(){
        // TODO: Populate onGesture method
        //
        // You can check the current state of the Cubit by using the [state] variable from `super`.
        // To change the current state, call the [emit()] method with the state of your choice.
      }
    }
    ''';
  }

  String getImportPath(PBSharedInstanceIntermediateNode node,
      FileStructureStrategy fileStrategy) {
    var generalStateName = node.functionCallName
        .substring(0, node.functionCallName.lastIndexOf('/'));
    var symbolMaster =
        PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID);
    return p.join(
      fileStrategy.GENERATED_PROJECT_PATH,
      FileStructureStrategy.RELATIVE_VIEW_PATH,
      '${generalStateName.snakeCase}_bloc',
      '${ImportHelper.getName(symbolMaster.name).snakeCase}_bloc',
    );
  }

  @override
  Future<PBIntermediateNode> handleStatefulNode(PBIntermediateNode node) {
    var managerData = node.managerData;
    node.currentContext.project.genProjectData
        .addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
    managerData.addImport(FlutterImport('flutter_bloc.dart', 'flutter_bloc'));

    var fileStrategy =
        configuration.fileStructureStrategy as BLoCFileStructureStrategy;

    /// Incase of SymbolInstance
    if (node is PBSharedInstanceIntermediateNode) {
      var generalStateName = node.functionCallName
          .substring(0, node.functionCallName.lastIndexOf('/'));
      if (node.generator is! StringGeneratorAdapter) {
        var nameWithCubit = '${generalStateName.pascalCase}Cubit';
        var nameWithState = '${generalStateName.pascalCase}State';
        var master =
            PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID);
        var namewithToWidget = '${master.name.camelCase}StateToWidget';

        node.generator = StringGeneratorAdapter('''
        LayoutBuilder(
          builder: (context, constraints){
            return BlocProvider<$nameWithCubit>(
              create: (context) => $nameWithCubit(),
              child: BlocBuilder<$nameWithCubit,$nameWithState>(
                builder: (context, state){
                  return GestureDetector(
                    child: $namewithToWidget(state, constraints),
                    onTap: () => context.read<$nameWithCubit>().onGesture(),
                  );
                }
              )
            );
          }
        )  
      ''');
      }

      return Future.value(node);
    }
    var parentState = getNameOfNode(node);
    var generalName = parentState.snakeCase;
    var blocDirectory =
        p.join(fileStrategy.RELATIVE_BLOC_PATH, '${generalName}_bloc');
    var states = <PBIntermediateNode>[node];

    var stateBuffer = StringBuffer();
    var mapBuffer = StringBuffer();

    node?.auxiliaryData?.stateGraph?.states?.forEach((state) {
      states.add(state.variation.node);
    });

    var isFirst = true;
    states.forEach((element) {
      element.currentContext.tree.data = node.managerData;
      element.generator.templateStrategy = BLoCStateTemplateStrategy(
        isFirst: isFirst,
        abstractClassName: parentState,
      );
      stateBuffer.write(generationManager.generate(element));

      isFirst = false;
    });

    /// Creates state page
    fileStrategy.commandCreated(WriteSymbolCommand(

        /// modified the [UUID] to prevent adding import because the state is
        /// using `part of` syntax already when importing the bloc
        'STATE${node.currentContext.tree.UUID}',
        '${generalName}_state',
        stateBuffer.toString(),
        symbolPath: blocDirectory));

    /// Creates map page
    mapBuffer.write(_makeStateToWidgetFunction(node));
    fileStrategy.commandCreated(WriteSymbolCommand(

        /// modified the [UUID] to prevent adding import because the event is
        /// using `part of` syntax already when importing the bloc
        'MAP${node.currentContext.tree.UUID}',
        '${generalName}_map',
        mapBuffer.toString(),
        symbolPath: blocDirectory));

    /// Creates cubit page
    managerData.addImport(FlutterImport('meta.dart', 'meta'));
    fileStrategy.commandCreated(WriteSymbolCommand(
        node.currentContext.tree.UUID,
        '${generalName}_cubit',
        _createBlocPage(
          parentState,
          node.name,
        ),
        symbolPath: blocDirectory));

    // Generate node's states' view pages
    node.auxiliaryData?.stateGraph?.states?.forEach((state) {
      fileStrategy.commandCreated(WriteSymbolCommand(
        state.variation.node.currentContext.tree.UUID,
        state.variation.node.name.snakeCase,
        generationManager.generate(state.variation.node),
        relativePath: generalName, //Generate view files separately
      ));
    });

    return Future.value(null);
  }

  String _makeStateToWidgetFunction(PBIntermediateNode element) {
    var stateBuffer = StringBuffer();
    var elementName =
        element.name.substring(0, element.name.lastIndexOf('/')).snakeCase;
    stateBuffer.write("import 'package:flutter/material.dart';");
    // TODO: replace dynamically
    stateBuffer.write(
        "import 'package:temp/widgets/${elementName}_bloc/${elementName}_cubit.dart';");

    stateBuffer.write(
        'Widget ${element.name.camelCase}StateToWidget( ${element.name.pascalCase}State state, BoxConstraints constraints) {');
    for (var i = 0; i < element.auxiliaryData.stateGraph.states.length; i++) {
      if (i == 0) {
        stateBuffer.write(_getStateLogic(
            element.auxiliaryData.stateGraph.states[i].variation.node, 'if'));
      } else {
        {
          stateBuffer.write(_getStateLogic(
              element.auxiliaryData.stateGraph.states[i].variation.node,
              'else if'));
        }
      }
    }

    stateBuffer.write('return ${element.name.pascalCase}(constraints); \n }');

    return stateBuffer.toString();
  }

  String _getStateLogic(PBIntermediateNode node, String statement) {
    return '''
      $statement (state is ${node.name.pascalCase}State){
        return ${node.name.pascalCase}(constraints);
      } \n
    ''';
  }
}
