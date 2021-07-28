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


class InjectedContainer extends PBVisualIntermediateNode
    implements PBInjectedIntermediate, PrototypeEnable {
  @override
  PrototypeNode prototypeNode;

  @override
  ChildrenStrategy childrenStrategy = TempChildrenStrategy('child');

  @override
  AlignStrategy alignStrategy = NoAlignment();//PaddingAlignment();

  InjectedContainer(
    Point bottomRightCorner,
    Point topLeftCorner,
    String name,
    String UUID, {
    String color,
    PBContext currentContext,
    PBIntermediateConstraints constraints,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, name,
            UUID: UUID, constraints: constraints) {
    generator = PBContainerGenerator();

    size = {
      'width': (bottomRightCorner.x - topLeftCorner.x).abs(),
      'height': (bottomRightCorner.y - topLeftCorner.y).abs(),
    };
  }

}
