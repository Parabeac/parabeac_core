import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/design_node.dart';

part 'rect.g.dart';

@JsonSerializable(nullable: false)
class Rect {
  Rect(
    this.x,
    this.y,
    this.width,
    this.height,
  );

  double x;
  double y;
  double width;
  double height;

  factory Rect.fromJson(Map<String, dynamic> json) => _$RectFromJson(json);
  Map<String, dynamic> toJson() => _$RectToJson(this);
}
