import 'package:json_annotation/json_annotation.dart';

part 'artboard.g.dart';

@JsonSerializable(nullable: false)
class Artboard {
  var backgroundColor;
  var designElement;
  var groupNode;
  Artboard(this.backgroundColor, this.designElement);

  factory Artboard.fromJson(Map<String, dynamic> json) =>
      _$ArtboardFromJson(json);
  Map<String, dynamic> toJson() => _$ArtboardToJson(this);
// 命名构造函数
  Artboard.empty();
}
