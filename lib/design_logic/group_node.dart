import 'package:json_annotation/json_annotation.dart';

import 'design_node.dart';

part 'group_node.g.dart';

@JsonSerializable(nullable: false)
abstract class GroupNode {
  GroupNode(
    this.children,
  );

  List<DesignNode> children;

  // factory GroupNode.fromJson(Map<String, dynamic> json) =>
  //     _$GroupNodeFromJson(json);
  Map<String, dynamic> toJson() => _$GroupNodeToJson(this);
}
