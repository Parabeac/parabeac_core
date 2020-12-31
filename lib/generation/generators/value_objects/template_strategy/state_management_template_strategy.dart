import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/state_management_wrappers/state_generator_wrapper.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class StateManagementTemplateStrategy extends TemplateStrategy {
  ///The [StateManagementWrapper] or configuration that is being used in the project, e.i. Provider or BLoC.
  final StateManagementWrapper _generator;
  TemplateStrategy _originalTemplateStrategy;
  set originalTemplateStrategy(TemplateStrategy strategy) =>
      _originalTemplateStrategy = strategy;
  TemplateStrategy get originalTeplateStrategy => _originalTemplateStrategy;

  StateManagementTemplateStrategy(this._generator);
  @override
  String generateTemplate(PBIntermediateNode node, PBGenerationManager manager,
      GeneratorContext generatorContext,
      {args}) {
    _generator.manager = manager;

    var generatedCode = node;
    return _generator.generate(node, generatorContext);
  }
}
