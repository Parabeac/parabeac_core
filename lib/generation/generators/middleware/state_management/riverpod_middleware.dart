import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/riverpod_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generator_adapter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import '../../pb_generation_manager.dart';
import '../../pb_variable.dart';
import '../middleware.dart';
import 'package:recase/recase.dart';

class RiverpodMiddleware extends Middleware {
  final PACKAGE_NAME = 'flutter_riverpod';
  final PACKAGE_VERSION = '^0.12.1';

  RiverpodMiddleware(PBGenerationManager generationManager)
      : super(generationManager);

  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    String watcherName;
    var managerData = node.managerData;
    var fileStrategy = node.currentContext.project.fileStructureStrategy
        as RiverpodFileStructureStrategy;

    if (node is PBSharedInstanceIntermediateNode) {
      node.currentContext.project.genProjectData
          .addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
      managerData.addImport('package:flutter_riverpod/all.dart');
      watcherName = node.functionCallName.snakeCase;
      var watcher = PBVariable(watcherName + '_provider', 'final ', true,
          'ChangeNotifierProvider((ref) => ${getName(node.functionCallName).pascalCase}())');

      managerData.addMethodVariable(watcher);
      await managerData.replaceImport(
          watcherName, 'models/${watcherName}.dart');
      node.generator = StringGeneratorAdapter(getConsumer(watcherName));
      return node;
    }
    watcherName = getNameOfNode(node);

    // Iterating through states
    var stateBuffer = StringBuffer();
    stateBuffer.write(_generateProviderVariable(node));
    node.auxiliaryData.stateGraph.states.forEach((state) async {
      var variationNode = state.variation.node;

      stateBuffer.write(_generateProviderVariable(variationNode));
    });

    var code = _generateRiverpodClass(stateBuffer.toString(), watcherName,
        generationManager, node.name.camelCase);
    fileStrategy.writeRiverpodModelFile(code, getName(node.name).snakeCase);

    return node;
  }

  String _generateRiverpodClass(String states, String defaultStateName,
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

  String getConsumer(String name) {
    return '''
    Consumer(
      builder: (context, watch, child) {
        final ${name} = watch(${name}_provider); 
        return ${name}.defaultWidget;
      },
    )
    ''';
  }
}
