import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class EmptyPageTemplateStrategy extends TemplateStrategy {
  @override
  String generateTemplate(PBIntermediateNode node, PBGenerationManager manager,
          GeneratorContext generatorContext,
          {var args}) =>
      args is String ? args : '';
}
