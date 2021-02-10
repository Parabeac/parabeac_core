import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/provider_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:recase/recase.dart';
import 'package:parabeac_core/generation/generators/value_objects/generator_adapter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class ProviderMiddleware extends Middleware {
  final PACKAGE_NAME = 'provider';
  final PACKAGE_VERSION = '^4.3.2+3';

  ProviderMiddleware(PBGenerationManager generationManager)
      : super(generationManager);

  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    String watcherName;
    var managerData = node.managerData;
    var fileStrategy = node.currentContext.project.fileStructureStrategy
        as ProviderFileStructureStrategy;

    if (node is PBSharedInstanceIntermediateNode) {
      node.currentContext.project.genProjectData
          .addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
      managerData.addImport('package:provider/provider.dart');
      watcherName = node.functionCallName.snakeCase;
      var watcher = PBVariable(watcherName, 'final ', true,
          'context.watch<${getName(node.functionCallName).pascalCase}>().defaultWidget');
      managerData.addMethodVariable(watcher);

      addImportToCache(node.SYMBOL_ID, getImportPath(node, fileStrategy));

      node.generator = StringGeneratorAdapter(watcherName);
      return node;
    }
    watcherName = getNameOfNode(node);
    if (node is PBSharedMasterNode) {
      node.name = watcherName;
    }

    // Iterating through states
    var stateBuffer = StringBuffer();
    stateBuffer.write(_generateProviderVariable(node));
    node.auxiliaryData.stateGraph.states.forEach((state) async {
      var variationNode = state.variation.node;

      stateBuffer.write(_generateProviderVariable(variationNode));
    });

    var code = _generateProviderClass(stateBuffer.toString(), watcherName,
        generationManager, node.name.camelCase);
    fileStrategy.writeProviderModelFile(code, getName(node.name).snakeCase);

    return node;
  }

  String _generateProviderClass(String states, String defaultStateName,
      PBGenerationManager manager, String defaultWidgetName) {
    return '''
      import 'package:flutter/material.dart';
      class ${defaultStateName} extends ChangeNotifier {
      ${states}

      Widget defaultWidget;
      ${defaultStateName}(){
        defaultWidget = ${defaultWidgetName};
      }
      }
      ''';
  }

  String _generateProviderVariable(PBIntermediateNode node) {
    return 'var ${node.name.camelCase} = ' +
        node?.generator?.generate(node ?? '',
            GeneratorContext(sizingContext: SizingValueContext.PointValue)) +
        ';';
  }

  String getImportPath(PBSharedInstanceIntermediateNode node, fileStrategy) {
    var symbolMaster =
        PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID);
    return fileStrategy.GENERATED_PROJECT_PATH +
        fileStrategy.RELATIVE_MODEL_PATH +
        '${getName(symbolMaster.name).snakeCase}.dart';
  }
}
