import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/color.dart';

part 'color.g.dart';

@JsonSerializable(nullable: true)
class Color implements PBColor {
  @JsonKey(name: '_class')
  final String classField;
  double alpha, blue, green, red;

  Color({this.alpha, this.blue, this.classField, this.green, this.red});

  factory Color.fromJson(Map json) => _$ColorFromJson(json);
  Map toJson() => _$ColorToJson(this);
}
