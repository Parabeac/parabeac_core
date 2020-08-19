import 'package:parabeac_core/generation/generators/pb_widget_manager.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class PBContext {
  PBConfiguration configuration;
  Point screenTopLeftCorner, screenBottomRightCorner;
  Map jsonConfigurations;
  PBGenerationManager _generationManager;
  PBGenerationManager get generationManager => _generationManager;
  set generationManager(PBGenerationManager manager) =>
      _generationManager = manager;

  PBContext({this.jsonConfigurations}) {
    assert(jsonConfigurations != null);
    var copyConfig = {}..addAll(jsonConfigurations);
    copyConfig.remove('default');

    configuration =
        PBConfiguration(jsonConfigurations['default'], jsonConfigurations);
    configuration.setConfigurations(jsonConfigurations);
  }
}
