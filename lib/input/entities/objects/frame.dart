import 'package:json_annotation/json_annotation.dart';

part 'frame.g.dart';

@JsonSerializable(nullable: false)
class Frame {
  @JsonKey(name: '_class')
  final String classField;
  final bool constrainProportions;
  double height, width, x, y;
  Frame({this.classField, this.constrainProportions, this.x,
  this.y, this.width, this.height});
  factory Frame.fromJson(Map<String, dynamic> json) => _$FrameFromJson(json);
  Map<String, dynamic> toJson() => _$FrameToJson(this);
}