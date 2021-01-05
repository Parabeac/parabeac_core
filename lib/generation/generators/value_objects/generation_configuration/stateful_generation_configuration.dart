import 'package:parabeac_core/generation/generators/middleware/state_management/stateful_management.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';

class StatefulGenerationConfiguration extends GenerationConfiguration {
  StatefulGenerationConfiguration();

  @override
  Future<void> setUpConfiguration() {
    registerMiddleware(StatefulMiddleware(generationManager));
    return super.setUpConfiguration();
  }
}
