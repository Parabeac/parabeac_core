import 'package:parabeac_core/generation/generators/middleware/state_management/stateful_management.dart';
import 'package:parabeac_core/generation/generators/state_management_wrappers/stateful_generator_wrapper.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/state_management_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class StatefulGenerationConfiguration extends GenerationConfiguration {
  TemplateStrategy _templateStrategy;

  StatefulGenerationConfiguration() {
    registerMiddleware(StatefulMiddleware());
    _templateStrategy = StateManagementTemplateStrategy(StatefulWrapper());
  }

  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    if (node?.auxiliaryData?.stateGraph?.states?.isNotEmpty ?? false) {
      node.generator.templateStrategy = _templateStrategy;
    }
    return node;
  }
}
