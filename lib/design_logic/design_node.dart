import 'package:json_annotation/json_annotation.dart';

part 'design_node.g.dart';

@JsonSerializable()
class DesignNode {
  DesignNode(
    this.UUID,
    this.name,
    this.isVisible,
    this.boundaryRectangle,
    this.type,
  );

  String UUID;
  String name;
  bool isVisible;
  var boundaryRectangle;
  String type;

  factory DesignNode.fromJson(Map<String, dynamic> json) =>
      _$DesignNodeFromJson(json);
  Map<String, dynamic> toJson() => _$DesignNodeToJson(this);
}
