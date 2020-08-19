class PBConfiguration {
  PBConfiguration(Map defaultConfig, this.specificConfig) {
    widgetStyle = defaultConfig['widgetStyle'];
    widgetType = defaultConfig['widgetStyle'];
    widgetSpacing = defaultConfig['widgetStyle'];
  }

  String widgetStyle;

  String widgetType;

  String widgetSpacing;

  Map specificConfig;

  void setConfigurations(Map configurations) {
    // Setting default configurations
    widgetStyle = configurations['default']['widgetSpacing'];
    widgetType = configurations['default']['widgetType'];
    widgetSpacing = configurations['default']['widgetSpacing'];
  }
}
