import 'dart:math';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_prototype_enabled.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

part 'injected_container.g.dart';

@JsonSerializable()
class InjectedContainer extends PBVisualIntermediateNode
    implements
        PBInjectedIntermediate,
        PrototypeEnable,
        IntermediateNodeFactory {
  @override
  @JsonKey(fromJson: PrototypeNode.prototypeNodeFromJson)
  PrototypeNode prototypeNode;

  @override
  @JsonKey()
  String type = 'injected_container';

  InjectedContainer(
    UUID,
    Rectangle frame, {
    String name,
    double alignX,
    double alignY,
    String color,
    this.prototypeNode,
    this.type,
  }) : super(
          UUID,
          frame,
          name,
        ) {
    generator = PBContainerGenerator();
    childrenStrategy = TempChildrenStrategy('child');
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$InjectedContainerFromJson(json);

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree) =>
      InjectedContainer.fromJson(json);
}
