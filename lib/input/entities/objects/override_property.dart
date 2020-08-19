import 'package:json_annotation/json_annotation.dart';
part 'override_property.g.dart';
@JsonSerializable(nullable: false)
/// title: Override Property
/// description: Defines override properties on symbol masters
class OverridableProperty{
  static final String CLASS_NAME = 'MSImmutableOverrideProperty';
  final String overrideName;
  final bool canOverride;

  OverridableProperty(this.overrideName, this.canOverride);

  factory OverridableProperty.fromJson(Map<String, dynamic> json) =>
      _$OverridablePropertyFromJson(json);
  Map<String, dynamic> toJson() => _$OverridablePropertyToJson(this);
}