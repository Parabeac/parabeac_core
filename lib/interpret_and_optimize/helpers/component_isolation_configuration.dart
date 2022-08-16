import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/component_isolation_generator.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/dashbook/dashbook_generator.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/widgetbook/widgetbook_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_project_data.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/services/component_isolation/dashbook_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/component_isolation/widgetbook_service.dart';

/// Class that bundles a ComponentIsolationGenerator and an AITHandler
/// to generate the component isolation package according to the type.
class ComponentIsolationConfiguration {
  ComponentIsolationGenerator generator;
  AITHandler service;

  ComponentIsolationConfiguration._internal(this.generator, this.service);

  factory ComponentIsolationConfiguration.getConfiguration(
    String type,
    PBGenerationProjectData projectData,
    IntegrationLevel integrationLevel,
  ) {
    if (integrationLevel == IntegrationLevel.themes) {
      return null;
    }
    switch (type.toLowerCase()) {
      case 'widgetbook':
        return ComponentIsolationConfiguration._internal(
            WidgetbookGenerator(projectData), WidgetBookService());
      case 'dashbook':
        return ComponentIsolationConfiguration._internal(
            DashbookGenerator(projectData), DashbookService());
      default:
        return null;
    }
  }
}
