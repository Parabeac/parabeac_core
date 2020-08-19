import 'package:json_annotation/json_annotation.dart';
part 'color_controls.g.dart';

@JsonSerializable(nullable: true)
class ColorControls{
  @JsonKey(name: '_class')
  final String classField;
  final bool isEnabled;
  final double brightness, contrast, hue, saturation;

  ColorControls({this.brightness, this.classField, this.contrast, this.hue, this.isEnabled, this.saturation});

  factory ColorControls.fromJson(Map json) =>_$ColorControlsFromJson(json);
  Map toJson() => _$ColorControlsToJson(this);
}
