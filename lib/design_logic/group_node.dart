import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
abstract class GroupNode {
  GroupNode(
    this.children,
  );

  List children;
}
