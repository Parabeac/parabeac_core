import 'package:json_annotation/json_annotation.dart';

part 'design_element.g.dart';

@JsonSerializable(nullable: false)
class DesignElement {
  var designNode;
  DesignElement(this.designNode);
  factory DesignElement.fromJson(Map<String, dynamic> json) =>
      _$DesignElementFromJson(json);
  Map<String, dynamic> toJson() => _$DesignElementToJson(this);
// 命名构造函数
  DesignElement.empty();
}
