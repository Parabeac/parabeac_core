import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/entities/style/color.dart';
part 'gradient_stop.g.dart';

@JsonSerializable(nullable: true)
class GradientStop{
  @JsonKey(name: '_class')
  final String classField;
  final double position;
  final Color color;

  GradientStop({this.classField, this.color, this.position});

  factory GradientStop.fromJson(Map json) =>_$GradientStopFromJson(json);
  Map toJson() => _$GradientStopToJson(this);
}
