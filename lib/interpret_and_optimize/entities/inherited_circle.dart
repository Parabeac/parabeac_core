import 'dart:math';

import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class InheritedCircle extends PBVisualIntermediateNode
    implements PBInheritedIntermediate {
  @override
  final originalRef;

  @override
  PrototypeNode prototypeNode;

  @override
  ChildrenStrategy childrenStrategy = TempChildrenStrategy('child');

  InheritedCircle(this.originalRef, Point bottomRightCorner,
      Point topLeftCorner, String name,
      {PBContext currentContext, Point alignX, Point alignY})
      : super(topLeftCorner, bottomRightCorner, currentContext, name,
            UUID: originalRef.UUID ?? '') {
    if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
    generator = PBBitmapGenerator();

    size = {
      'width': originalRef.boundaryRectangle.width,
      'height': originalRef.boundaryRectangle.height,
    };

    auxiliaryData.borderInfo = {};
    auxiliaryData.borderInfo['shape'] = 'circle';
  }

  @override
  void alignChild() {
    // var padding = Padding('', child.constraints,
    //     left: (child.topLeftCorner.x - topLeftCorner.x).abs(),
    //     right: (bottomRightCorner.x - child.bottomRightCorner.x).abs(),
    //     top: (child.topLeftCorner.y - topLeftCorner.y).abs(),
    //     bottom: (child.bottomRightCorner.y - bottomRightCorner.y).abs(),
    //     topLeftCorner: topLeftCorner,
    //     bottomRightCorner: bottomRightCorner,
    //     currentContext: currentContext);
    // padding.addChild(child);
    // child = padding;
  }
}
