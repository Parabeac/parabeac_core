import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/group/group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/layout_exception.dart';
import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

part 'frame_group.g.dart';

@JsonSerializable(ignoreUnannotated: true, createToJson: true)

/// When creating [FrameGroup]s that is not from JSON (In other words, its being injected rather than inherited)
/// the values for the [PBIntermediateConstraints] are going to be [PBIntermediateConstraints.defaultConstraints()].
/// Furthermore, the [frame] is going to be as big as it could be if the [FrameGroup] was injected rather than derived
/// from the JSON file.
class FrameGroup extends Group {
  @override
  @JsonKey()
  String type = 'frame';

  FrameGroup(String UUID, Rectangle<num> frame,
      {String name,
      PrototypeNode prototypeNode,
      PBIntermediateConstraints constraints})
      : super(UUID, frame,
            name: name, prototypeNode: prototypeNode, constraints: constraints);

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
          PBIntermediateNode parent, PBIntermediateTree tree) =>
      _$FrameGroupFromJson(json)
        ..mapRawChildren(json, tree)
        ..originalRef = json;
}
