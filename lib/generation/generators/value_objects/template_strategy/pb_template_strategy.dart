import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

abstract class TemplateStrategy {
  String generateTemplate(PBIntermediateNode node, PBGenerationManager manager,
      GeneratorContext generatorContext,
      {var args});
  String retrieveNodeName(var node) {
    var formatter = (name) => PBInputFormatter.formatLabel(name,
        isTitle: true, spaceToUnderscore: false);
    var widgetName;
    if (node is PBIntermediateNode) {
      widgetName = formatter(node.name);
    } else if (node is String) {
      widgetName = formatter(node);
    } else {
      widgetName = node;
    }
    return widgetName;
  }
}
