import 'dart:math';

import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

import 'group.dart';

part 'base_group.g.dart';

@JsonSerializable(ignoreUnannotated: true, createToJson: true)

/// A temporary node that must be removed
class BaseGroup extends Group
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  BaseGroup(
    String UUID,
    Rectangle3D frame, {
    Map<String, dynamic> originalRef,
    String name,
    PrototypeNode prototypeNode,
    constraints,
  }) : super(
          UUID,
          frame,
          name: name,
          prototypeNode: prototypeNode,
          originalRef: originalRef,
          constraints: constraints,
        );

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
          PBIntermediateNode parent, PBIntermediateTree tree) =>
      _$BaseGroupFromJson(json)
        ..mapRawChildren(json, tree)
        ..originalRef = json;
}
