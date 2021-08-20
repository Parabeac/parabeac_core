import 'dart:math';

import 'package:parabeac_core/generation/generators/visual-widgets/pb_align_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/group/group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class InjectedAlign extends PBVisualIntermediateNode
    implements PBInjectedIntermediate {
  double alignX;
  double alignY;

  InjectedAlign(String UUID, Rectangle frame, String name)
      : super(UUID, frame, name) {
    generator = PBAlignGenerator();
    childrenStrategy = TempChildrenStrategy('child');
  }

  @override
  void alignChild() {
    // var maxX = (frame.topLeft.x - frame.bottomRight.x).abs() -
    //     (child.frame.bottomRight.x - child.frame.topLeft.x).abs();
    // var parentCenterX = (frame.topLeft.x + frame.bottomRight.x) / 2;
    // var childCenterX = (child.frame.topLeft.x + child.frame.bottomRight.x) / 2;
    // var alignmentX = 0.0;

    // if (maxX != 0.0) {
    //   alignmentX = ((childCenterX - parentCenterX) / maxX) * 2;
    // }

    // var parentCenterY = (frame.topLeft.y + frame.bottomRight.y) / 2;
    // var maxY = (frame.topLeft.y - frame.bottomRight.y).abs() -
    //     (child.frame.bottomRight.y - child.frame.topLeft.y).abs();
    // var childCenterY = (child.frame.topLeft.y + child.frame.bottomRight.y) / 2;
    // var alignmentY = ((childCenterY - parentCenterY) / maxY) * 2;

    // if (maxY != 0.0) {
    //   alignmentY = ((childCenterY - parentCenterY) / maxY) * 2;
    // }

    // if (alignmentX.isNaN) {
    //   alignmentX = 0;
    // }
    // if (alignmentY.isNaN) {
    //   alignmentY = 0;
    // }

    // alignX = alignmentX.toDouble();
    // alignY = alignmentY.toDouble();
  }

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) => null;
}
