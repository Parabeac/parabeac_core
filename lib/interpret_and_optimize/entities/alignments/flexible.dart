import 'package:parabeac_core/generation/generators/visual-widgets/pb_flexible_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'dart:math';

import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class Flexible extends PBVisualIntermediateNode {
  int flex;

  @override
  ChildrenStrategy childrenStrategy = OneChildStrategy('child');


  //TODO: Find a way to make currentContext required
  //without breaking the json serializable
  Flexible(
    String UUID, {
    PBContext currentContext,
    child,
    this.flex,
    Point topLeftCorner,
    Point bottomRightCorner,
  }) : super(
          topLeftCorner,
          bottomRightCorner,
          currentContext,
          '',
          UUID: UUID,
        ) {
    generator = PBFlexibleGenerator();
    this.child = child;
  }

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) => null;
}
