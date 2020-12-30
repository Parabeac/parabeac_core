import 'package:parabeac_core/generation/generators/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/state_management/provider_management.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/provider_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/state_management_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class ProviderGenerationConfiguration extends GenerationConfiguration {
  TemplateStrategy _templateStrategy;
  PBGenerator _providerGenerator;
  ProviderGenerationConfiguration() {
    _providerGenerator = ProviderGeneratorWrapper();
    _templateStrategy = StateManagementTemplateStrategy(_providerGenerator);
  }

  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    if (node?.auxiliaryData?.stateGraph?.states?.isNotEmpty ?? false) {
      node.generator.templateStrategy = _templateStrategy;
    }
    return node;
  }

  @override
  Future<void> setUpConfiguration() async {
    fileStructureStrategy = ProviderFileStructureStrategy(
        intermediateTree.projectAbsPath, PBFlutterWriter(), intermediateTree);
    logger.info('Setting up the directories');
    await fileStructureStrategy.setUpDirectories();
  }
}
