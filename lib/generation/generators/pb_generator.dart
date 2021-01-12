import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/inline_template_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import 'attribute-helper/pb_generator_context.dart';

abstract class PBGenerator {
  final String OBJECTID = 'UUID';

  ///The [TemplateStrategy] that is going to be used to generate the boilerplate code around the node.
  ///
  ///The `default` [TemplateStrategy] is going to be [InlineTemplateStrategy]
  TemplateStrategy _templateStrategy;
  TemplateStrategy get templateStrategy => _templateStrategy;
  set templateStrategy(TemplateStrategy strategy) =>
      _templateStrategy = strategy;

  PBGenerationManager _manager = PBFlutterGenerator(null);
  set manager(PBGenerationManager generationManager) =>
      _manager = generationManager;
  PBGenerationManager get manager => _manager;

  PBGenerator({TemplateStrategy strategy}) {
    _templateStrategy = strategy;
    _templateStrategy ??= InlineTemplateStrategy();
  }

  String generate(PBIntermediateNode source, GeneratorContext generatorContext);
}
