import 'package:json_annotation/json_annotation.dart';

part 'star.g.dart';

@JsonSerializable()
class Star {
  Star();
  factory Star.fromJson(Map<String, dynamic> json) => _$StarFromJson(json);
  Map<String, dynamic> toJson() => _$StarToJson(this);
// 命名构造函数
  Star.empty();
}
