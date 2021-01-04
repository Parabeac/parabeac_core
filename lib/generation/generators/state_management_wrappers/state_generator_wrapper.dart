import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

abstract class StateManagementWrapper extends PBGenerator {
  /// This method should be called when a PBIntermediateNode contains other states.
  /// The method's responsibility is to communicate to the configured state management system and return the state call code.
  ///
  /// The [node]'s state graph will be iterated through to generate each variation
  /// with the helper of [manager]. The [path] should be an absolute path to
  /// the directory where [node] will be generated.
  String setStatefulNode(
    PBIntermediateNode node,
    PBGenerationManager manager,
    String path,
  );
  String getNameOfNode(PBIntermediateNode node) {
    var name = node.name;
    var index = name.indexOf('/');
    // Remove everything after the /. So if the name is SignUpButton/Default, we end up with SignUpButton as the name we produce.
    name.replaceRange(index, name.length, '');
    return name;
  }

  @override
  String generate(
      PBIntermediateNode source, GeneratorContext generatorContext) {
    var watcherName = getNameOfNode(source);
    var fileStrategy = manager.fileStrategy;
    source.auxiliaryData.stateGraph.states.forEach((element) {
      var node = element.variation.node;
      fileStrategy.generatePage(
          node.generator.generate(node, generatorContext), getNameOfNode(node),
          args: 'VIEW');
    });
    return source.generator.generate(source, generatorContext);
  }
}
