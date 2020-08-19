
import 'package:json_annotation/json_annotation.dart';
part 'pb_symbol_master_overridable_prop.g.dart';
@JsonSerializable(nullable: false)
class PBSymbolMasterOverridableProperty{
  final bool canOverride;
  final String overrideName;

  PBSymbolMasterOverridableProperty(this.canOverride, this.overrideName);

  factory PBSymbolMasterOverridableProperty.fromJson(Map<String, Object> json) =>
      _$PBSymbolMasterOverridablePropertyFromJson(json);

  String get symbolId => overrideName?.replaceAll(RegExp('_.+'), '');

  @override
  Map<String, Object> toJson() => _$PBSymbolMasterOverridablePropertyToJson(this);
}