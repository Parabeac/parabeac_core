import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/middleware/state_management/utils/middleware_utils.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/riverpod_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generator_adapter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
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
    var overrideProps = <PBSharedParameterProp>[];

    if (node is PBSharedInstanceIntermediateNode) {
      node.currentContext.project.genProjectData
          .addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
      managerData.addImport('package:flutter_riverpod/flutter_riverpod.dart');
      watcherName = node.functionCallName.snakeCase;
      var watcher = PBVariable(watcherName + '_provider', 'final ', true,
          'ChangeNotifierProvider((ref) => ${getName(node.functionCallName).pascalCase}())');

      managerData.addMethodVariable(watcher);

      addImportToCache(node.SYMBOL_ID, getImportPath(node, fileStrategy));

      node.generator = StringGeneratorAdapter(getConsumer(watcherName));
      return node;
    } else if (node is PBSharedMasterNode) {
      overrideProps.addAll(node.overridableProperties ?? []);
    }
    watcherName = getNameOfNode(node);
    // Iterating through states
    var stateBuffer = StringBuffer();
    stateBuffer.write(MiddlewareUtils.generateVariable(node));
    node.auxiliaryData.stateGraph.states.forEach((state) async {
      var variationNode = state.variation.node;

      if (variationNode is PBSharedMasterNode) {
        overrideProps.addAll(variationNode.overridableProperties ?? []);
      }

      stateBuffer.write(MiddlewareUtils.generateVariable(variationNode));
    });

    var code = MiddlewareUtils.generateChangeNotifierClass(
      stateBuffer.toString(),
      watcherName,
      generationManager,
      node.name.camelCase,
      overrideProperties: overrideProps,
    );
    fileStrategy.writeRiverpodModelFile(code, getName(node.name).snakeCase);

    return node;
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

  String getImportPath(PBSharedInstanceIntermediateNode node, fileStrategy) {
    var symbolMaster =
        PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID);
    return fileStrategy.GENERATED_PROJECT_PATH +
        fileStrategy.RELATIVE_MODEL_PATH +
        '${getName(symbolMaster.name).snakeCase}.dart';
  }
}
