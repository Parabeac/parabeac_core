import 'package:json_annotation/json_annotation.dart';

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
// 命名构造函数
  Rect.empty();
}
