import 'package:json_annotation/json_annotation.dart';

part 'color.g.dart';

@JsonSerializable(nullable: false)
class Color {
  Color(
    this.alpha,
    this.red,
    this.green,
    this.blue,
  );

  double alpha;
  double red;
  double green;
  double blue;

  factory Color.fromJson(Map<String, dynamic> json) => _$ColorFromJson(json);
  Map<String, dynamic> toJson() => _$ColorToJson(this);
// 命名构造函数
  Color.empty();
}
