import 'package:json_annotation/json_annotation.dart';

part 'pb_prototype_node.g.dart';

@JsonSerializable(nullable: true)
class PrototypeNode {
  PrototypeNode(this.destinationUUID, {this.destinationName});
  String destinationUUID;
  String destinationName;
  factory PrototypeNode.fromJson(Map<String, dynamic> json) => _$PrototypeNodeFromJson(json);
  Map<String, dynamic> toJson() => _$PrototypeNodeToJson(this);
}
