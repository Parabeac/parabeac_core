import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/provider_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
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
      node.generator = StringGeneratorAdapter(watcherName);
      return node;
    }
    watcherName = getNameOfNode(node);

    // Iterating through states
    var stateBuffer = StringBuffer();
    stateBuffer.write(_generateProviderVariable(node, isDefault: true));
    node.auxiliaryData.stateGraph.states.forEach((state) async {
      var variationNode = state.variation.node;

      stateBuffer.write(_generateProviderVariable(variationNode));
    });

    var code = _generateProviderClass(
        stateBuffer.toString(), watcherName, generationManager);
    fileStrategy.writeProviderModelFile(code, node.name.snakeCase);
  }

  String _generateProviderClass(
      String states, String defaultStateName, PBGenerationManager manager) {
    return '''
      import 'package:flutter/material.dart';
      class ${defaultStateName} extends ChangeNotifier {
      ${states}
      }
      ''';
  }

  String _generateProviderVariable(PBIntermediateNode node,
      {bool isDefault = false}) {
    return 'var ${isDefault ? 'defaultWidget' : node.name.camelCase} = ' +
        node?.generator?.generate(node ?? '',
            GeneratorContext(sizingContext: SizingValueContext.PointValue)) +
        ';';
  }
}
