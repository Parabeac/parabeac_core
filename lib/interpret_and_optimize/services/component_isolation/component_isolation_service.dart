import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/component_isolation_configuration.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/widgetbook/widgetbook_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/services/component_isolation/widgetbook_service.dart';

abstract class ComponentIsolationService extends AITHandler {}

class ComponentIsolationFactory {
  static final Map<String, ComponentIsolationTuple> _isolationServices = {
    'widgetbook':
        ComponentIsolationTuple(WidgetBookService(), WidgetbookConfiguration()),
  };
  static ComponentIsolationTuple getTuple(String serviceName) =>
      _isolationServices[serviceName];
}

/// Class that holds a [ComponentIsolationService] and the [ComponentIsolationConfiguration] that
/// will be executed after the interpretation is complete.
class ComponentIsolationTuple {
  final ComponentIsolationService service;
  final ComponentIsolationConfiguration configuration;

  ComponentIsolationTuple(this.service, this.configuration);
}
