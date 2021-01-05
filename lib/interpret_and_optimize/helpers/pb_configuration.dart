import 'package:parabeac_core/controllers/main_info.dart';

class PBConfiguration {
  PBConfiguration(Map defaultConfig, this.specificConfig) {
    widgetStyle = defaultConfig['widgetStyle'];
    widgetType = defaultConfig['widgetType'];
    widgetSpacing = defaultConfig['widgetSpacing'];
    layoutPrecedence =
        defaultConfig['layoutPrecedence'] ?? ['column', 'row', 'stack'];
    stateManagement = defaultConfig['stateManagement'] ?? 'provider';
  }

  String widgetStyle;

  String widgetType;

  String widgetSpacing;

  String stateManagement;

  List<dynamic> layoutPrecedence;

  Map specificConfig;

  // not sure why setConfigurations(), so replaced with this class variable
  Map configurations;
}
