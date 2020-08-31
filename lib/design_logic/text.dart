import 'package:json_annotation/json_annotation.dart';

part 'text.g.dart';

@JsonSerializable()
class Text {
  Text(
    this.content,
  );

  String content;

  factory Text.fromJson(Map<String, dynamic> json) => _$TextFromJson(json);
  Map<String, dynamic> toJson() => _$TextToJson(this);
// 命名构造函数
  Text.empty();
}
