import 'package:json_annotation/json_annotation.dart';

class PBSymbolMasterOverridableProperty {
  final bool canOverride;
  final String overrideName;

  PBSymbolMasterOverridableProperty(this.canOverride, this.overrideName);
}
