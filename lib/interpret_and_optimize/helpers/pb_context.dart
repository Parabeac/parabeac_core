import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class PBContext {
  PBConfiguration configuration;
  Point screenTopLeftCorner, screenBottomRightCorner;
  Map jsonConfigurations;

  PBContext({this.jsonConfigurations}) {
    assert(jsonConfigurations != null);
    var copyConfig = {}..addAll(jsonConfigurations);
    copyConfig.remove('default');

    configuration =
        PBConfiguration(jsonConfigurations['default'], jsonConfigurations);
    configuration.setConfigurations(jsonConfigurations);
  }
}
