import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/state_management_wrappers/state_generator_wrapper.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class ProviderGeneratorWrapper extends StateManagementWrapper {
  final PACKAGE_NAME = 'provider';
  final PACKAGE_VERSION = '1.0.0';

  @override
  String setStatefulNode(
      PBIntermediateNode node, PBGenerationManager manager, String path) {}

  String providerModelGenerator() {
    return ''' 
      import ...
    ''';
  }

  @override
  String generate(
      PBIntermediateNode source, GeneratorContext generatorContext) {
    var watcherName = getNameOfNode(source);
    var fileStrategy = manager.fileStrategy;
    var watcher = PBVariable(watcherName, 'final ', true, 'watch(context)');
    manager.addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
    manager.addImport('import provider');
    manager.addMethodVariable(watcher);
    fileStrategy.generatePage(
        source.generator.generate(source, generatorContext),
        '${fileStrategy.GENERATED_PROJECT_PATH}${fileStrategy.RELATIVE_VIEW_PATH}EDDIE.g.dart');
    return PBInputFormatter.formatLabel(watcherName);
  }
}
