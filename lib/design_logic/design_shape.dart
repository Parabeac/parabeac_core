import 'package:json_annotation/json_annotation.dart';

part 'design_shape.g.dart';

@JsonSerializable()
class DesignShape {
  var designElement;
  DesignShape(this.designElement);
  factory DesignShape.fromJson(Map<String, dynamic> json) =>
      _$DesignShapeFromJson(json);
  Map<String, dynamic> toJson() => _$DesignShapeToJson(this);
// 命名构造函数
  DesignShape.empty();
}
