import 'package:json_annotation/json_annotation.dart';
part 'override_value.g.dart';
@JsonSerializable(nullable: false)
/// title: Override Property
/// description: Defines override properties on symbol masters
class OverridableValue{
  static final String CLASS_NAME = 'overrideValue';
  final String overrideName;
  final String do_objectID;
  final dynamic value;

  OverridableValue(this.overrideName, this.do_objectID, this.value);

  factory OverridableValue.fromJson(Map<String, dynamic> json) =>
      _$OverridableValueFromJson(json);
  Map<String, dynamic> toJson() => _$OverridableValueToJson(this);
}