import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable()
class Image {
  Image(
    this.imageReference,
    this.name,
  );

  String imageReference;
  String name;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
  Map<String, dynamic> toJson() => _$ImageToJson(this);
// 命名构造函数
  Image.empty();
}
