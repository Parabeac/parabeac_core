import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/state_management_middleware.dart';
import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/flutter_file_structure_strategy.dart';
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
        configuration.fileStructureStrategy as FlutterFileStructureStrategy;

    /// Incase of SymbolInstance
    if (node is PBSharedInstanceIntermediateNode) {
      var generalStateName = node.functionCallName
          .substring(0, node.functionCallName.lastIndexOf('/'));

      var globalVariableName = getVariableName(node.name.snakeCase);
      managerData.addGlobalVariable(PBVariable(globalVariableName, 'var ', true,
          '${generalStateName.pascalCase}Bloc()'));

      addImportToCache(node.SYMBOL_ID, getImportPath(node, fileStrategy));

      managerData.addToDispose('$globalVariableName.close()');
      if (node.generator is! StringGeneratorAdapter) {
        node.generator = StringGeneratorAdapter('''
      BlocBuilder<${generalStateName.pascalCase}Bloc, ${generalStateName.pascalCase}State>(
        cubit: $globalVariableName,
        builder: (context, state) => state.widget  
      )
      ''');
      }
      return Future.value(node);
    }
    var parentState = getNameOfNode(node);
    var generalName = parentState.snakeCase;
    var parentDirectory = generalName + '_bloc';
    var states = <PBIntermediateNode>[node];

    var stateBuffer = StringBuffer();

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
        relativePath: parentDirectory));

    /// Creates event page
    fileStrategy.commandCreated(WriteSymbolCommand(

        /// modified the [UUID] to prevent adding import because the event is
        /// using `part of` syntax already when importing the bloc
        'EVENT${node.currentContext.tree.UUID}',
        '${generalName}_event',
        _createEventPage(parentState),
        relativePath: parentDirectory));

    /// Creates bloc page
    managerData.addImport(FlutterImport('meta.dart', 'meta'));
    fileStrategy.commandCreated(WriteSymbolCommand(
        node.currentContext.tree.UUID,
        '${generalName}_bloc',
        _createBlocPage(
          parentState,
          node.name,
        ),
        relativePath: parentDirectory));

    return Future.value(node);
  }
}
