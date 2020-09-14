import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/rect.dart';

part 'frame.g.dart';

@JsonSerializable(nullable: true)
class Frame implements Rect {
  @JsonKey(name: '_class')
  final String classField;
  final bool constrainProportions;
  @override
  double height, width, x, y;
  Frame({
    this.classField,
    this.constrainProportions,
    this.x,
    this.y,
    this.width,
    this.height,
  });
  factory Frame.fromJson(Map<String, dynamic> json) => _$FrameFromJson(json);
  Map<String, dynamic> toJson() => _$FrameToJson(this);
}
