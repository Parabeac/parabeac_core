import 'package:parabeac_core/generation/generators/visual-widgets/pb_flexible_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'dart:math';

class Flexible extends PBVisualIntermediateNode {
  int flex;

  @override
  var currentContext;

  @override
  final String UUID;

  @override
  ChildrenStrategy childrenStrategy = OneChildStrategy('child');

  //TODO: Find a way to make currentContext required
  //without breaking the json serializable
  Flexible(
    this.UUID, {
    this.currentContext,
    child,
    this.flex,
    this.topLeftCorner,
    this.bottomRightCorner,
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
  Point topLeftCorner;

  @override
  Point bottomRightCorner;

  @override
  void alignChild() {}
}
