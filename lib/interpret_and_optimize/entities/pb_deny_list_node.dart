import 'dart:math';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

/// A node that should not be converted to intermediate.
class PBDenyListNode extends PBIntermediateNode {
  @override
  ChildrenStrategy childrenStrategy = NoChildStrategy();
  PBDenyListNode(
    String UUID,
    Rectangle frame, {
    String name,
    PBContext currentContext,
  }) : super(
          UUID,
          frame,
          name,
          currentContext: currentContext,
        );

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) => null;
}
