import 'package:json_annotation/json_annotation.dart';
part 'override_value.g.dart';

@JsonSerializable(nullable: true)

/// title: Override Property
/// description: Defines override properties on symbol masters
class OverridableValue {
  static final String CLASS_NAME = 'overrideValue';
  final String overrideName;
  @JsonKey(name: 'do_objectID')
  final String UUID;
  final dynamic value;

  OverridableValue(this.overrideName, this.UUID, this.value);

  factory OverridableValue.fromJson(Map<String, dynamic> json) =>
      _$OverridableValueFromJson(json);
  Map<String, dynamic> toJson() => _$OverridableValueToJson(this);
}
