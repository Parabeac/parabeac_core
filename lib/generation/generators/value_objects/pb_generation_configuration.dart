import 'package:parabeac_core/generation/generators/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/state_management/provider_management.dart';
import 'package:parabeac_core/generation/generators/value_objects/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/pb_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_state_management_linker.dart';

abstract class GenerationConfiguration {
  FileStructureStrategy _fileStructureStrategy;
  FileStructureStrategy get fileStructureStrategy {
    if (_fileStructureStrategy == null) {
      throw Exception(
          'Do not forget to initialize the fileStructure by calling `initializeFileStructure()`');
    }
    return _fileStructureStrategy;
  }

  GenerationConfiguration();

  ///This is going to modify the [PBIntermediateNode] in order to affect the structural patterns or file structure produced.
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node);

  Future<void> initializeFileStructure(
      String absolutePath, PBIntermediateTree projectIntermediateTree);
}

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
  Future<void> initializeFileStructure(
      String absolutePath, PBIntermediateTree projectIntermediateTree) async {
    // Wait for State Management nodes to finish being interpreted
    await Future.wait(PBStateManagementLinker().stateQueue);
    _fileStructureStrategy = ProviderFileStructureStrategy(
        absolutePath, PBFlutterWriter(), projectIntermediateTree);
    await _fileStructureStrategy.initializeProject();
  }
}

class StatefulGenerationConfiguraiton extends GenerationConfiguration {
  StatefulGenerationConfiguraiton();

  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) {
    return Future.value(node);
  }

  @override
  Future<void> initializeFileStructure(
      String absolutePath, PBIntermediateTree projectIntermediateTree) async {
    _fileStructureStrategy = FlutterFileStructureStrategy(
        absolutePath, PBFlutterWriter(), projectIntermediateTree);
    await _fileStructureStrategy.initializeProject();
  }
}
