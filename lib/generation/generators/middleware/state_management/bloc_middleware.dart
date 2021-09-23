import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/state_management_middleware.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/bloc_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generator_adapter.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/bloc_state_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/element_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:recase/recase.dart';
import '../../pb_flutter_generator.dart';
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
  Future<PBIntermediateNode> handleStatefulNode(
      PBIntermediateNode node, PBContext context) {
    // var managerData = node.managerData;
    context.project.genProjectData
        .addDependencies(PACKAGE_NAME, PACKAGE_VERSION);

    var fileStrategy =
        configuration.fileStructureStrategy as BLoCFileStructureStrategy;

    var elementStorage = ElementStorage();

    /// Incase of SymbolInstance
    if (node is PBSharedInstanceIntermediateNode) {
      var generalStateName = node.functionCallName
          .substring(0, node.functionCallName.lastIndexOf('/'));
      context.managerData
          .addImport(FlutterImport('flutter_bloc.dart', 'flutter_bloc'));

      /// Get the default node's tree in order to add to dependent of the current tree.
      ///
      /// This ensures we have the correct modoel imports when generating the tree.
      var defaultNodeTreeUUID = elementStorage
          .elementToTree[stmgHelper.getStateGraphOfNode(node).defaultNode.UUID];
      var defaultNodeTree = elementStorage.treeUUIDs[defaultNodeTreeUUID];

      context.tree.addDependent(defaultNodeTree);
      if (node.generator is! StringGeneratorAdapter) {
        var nameWithCubit = '${generalStateName.pascalCase}Cubit';
        var nameWithState = '${generalStateName.pascalCase}State';
        var namewithToWidget = '${generalStateName.camelCase}StateToWidget';

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

    var stateGraph = stmgHelper.getStateGraphOfNode(node);
    stateGraph?.states?.forEach(states.add);

    var isFirst = true;
    states.forEach((element) {
      // element.currentContext.tree.data = node.managerData;

      // Creating copy of template to generate State
      var templateCopy = element.generator.templateStrategy;

      element.generator.templateStrategy = BLoCStateTemplateStrategy(
        isFirst: isFirst,
        abstractClassName: parentState,
      );
      stateBuffer.write(generationManager.generate(element, context));

      element.generator.templateStrategy = templateCopy;

      isFirst = false;
    });

    /// Creates state page
    fileStrategy.commandCreated(WriteSymbolCommand(
      /// modified the [UUID] to prevent adding import because the state is
      /// using `part of` syntax already when importing the bloc
      'STATE${context.tree.UUID}',
      '${generalName}_state',
      stateBuffer.toString(),
      symbolPath: blocDirectory,
      ownership: FileOwnership.DEV,
    ));

    /// Creates map page
    mapBuffer.write(_makeStateToWidgetFunction(node));
    fileStrategy.commandCreated(WriteSymbolCommand(
      /// modified the [UUID] to prevent adding import because the event is
      /// using `part of` syntax already when importing the bloc
      '${context.tree.UUID}',
      '${generalName}_map',
      mapBuffer.toString(),
      symbolPath: blocDirectory,
      ownership: FileOwnership.DEV,
    ));

    // Generate node's states' view pages
    stateGraph?.states?.forEach((state) {
      var treeUUID = elementStorage.elementToTree[state.UUID];
      var tree = elementStorage.treeUUIDs[treeUUID];
      // generate imports for state view
      var data = PBGenerationViewData()
        ..addImport(FlutterImport('material.dart', 'flutter'));
      tree.generationViewData.importsList.forEach(data.addImport);
      tree.context.generationManager =
          PBFlutterGenerator(ImportHelper(), data: data);

      fileStrategy.commandCreated(WriteSymbolCommand(
        tree.UUID,
        state.name.snakeCase,
        tree.context.generationManager.generate(state, tree.context),
        relativePath: generalName,
      ));
    });

    // Generate default node's view page
    fileStrategy.commandCreated(WriteSymbolCommand('${context.tree.UUID}',
        node.name.snakeCase, generationManager.generate(node, context),
        relativePath: generalName));

    /// Creates cubit page
    context.managerData.addImport(FlutterImport('meta.dart', 'meta'));
    context.managerData
        .addImport(FlutterImport('flutter_bloc.dart', 'flutter_bloc'));
    fileStrategy.commandCreated(WriteSymbolCommand(
      context.tree.UUID,
      '${generalName}_cubit',
      _createBlocPage(
        parentState,
        node.name,
      ),
      symbolPath: blocDirectory,
      ownership: FileOwnership.DEV,
    ));

    return Future.value(null);
  }

  String _makeStateToWidgetFunction(PBIntermediateNode element) {
    var stateBuffer = StringBuffer();
    var importBuffer = StringBuffer();
    var stateGraph = stmgHelper.getStateGraphOfNode(element);
    var elementName =
        element.name.substring(0, element.name.lastIndexOf('/')).snakeCase;
    importBuffer.write("import 'package:flutter/material.dart'; \n");
    importBuffer.write(
        "import 'package:${MainInfo().projectName}/blocs/${elementName}_bloc/${elementName}_cubit.dart';\n");

    stateBuffer.write(
        'Widget ${elementName.camelCase}StateToWidget( ${elementName.pascalCase}State state, BoxConstraints constraints) {');
    for (var i = 0; i < stateGraph.states.length; i++) {
      var node = stateGraph.states[i];
      if (i == 0) {
        stateBuffer.write(_getStateLogic(node, 'if'));
      } else {
        {
          stateBuffer.write(_getStateLogic(node, 'else if'));
        }
      }
      //TODO: leverage the imports system to generate these imports
      importBuffer.write(
          "import 'package:${MainInfo().projectName}/widgets/$elementName/${node.name.snakeCase}.g.dart'; \n");
    }
    importBuffer.write(
        "import 'package:${MainInfo().projectName}/widgets/$elementName/${element.name.snakeCase}.g.dart'; \n");
    stateBuffer.write('return ${element.name.pascalCase}(constraints); \n }');

    return importBuffer.toString() + stateBuffer.toString();
  }

  String _getStateLogic(PBIntermediateNode node, String statement) {
    return '''
      $statement (state is ${node.name.pascalCase}State){
        return ${node.name.pascalCase}(constraints);
      } \n
    ''';
  }
}
