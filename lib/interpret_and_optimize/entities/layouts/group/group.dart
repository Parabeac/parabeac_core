import 'dart:math';

import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';

// @JsonSerializable(ignoreUnannotated: true, explicitToJson: true)

/// A temporary node that must be removed
abstract class Group extends PBLayoutIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey(
      fromJson: PrototypeNode.prototypeNodeFromJson, name: 'prototypeNodeUUID')
  PrototypeNode prototypeNode;

  @override
  @JsonKey()
  String type = 'group';

  @override
  Map<String, dynamic> originalRef;

  Group(
    String UUID,
    Rectangle3D frame, {
    this.originalRef,
    String name,
    this.prototypeNode,
    constraints,
  }) : super(
          UUID,
          frame,
          [],
          [],
          name,
          constraints: constraints,
          prototypeNode: prototypeNode,
        );

  @override
  bool satisfyRules(PBContext context, PBIntermediateNode currentNode,
      PBIntermediateNode nextNode) {
    assert(false, 'Attempted to satisfyRules for class type [$runtimeType]');
    return null;
  }

  @override
  PBLayoutIntermediateNode generateLayout(List<PBIntermediateNode> children,
      PBContext currentContext, String name) {
    assert(false, 'Attempted to generateLayout for class type [$runtimeType]');
    return null;
  }
}
