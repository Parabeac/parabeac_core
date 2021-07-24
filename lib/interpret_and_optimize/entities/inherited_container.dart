import 'dart:math';

import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class InheritedContainer extends PBVisualIntermediateNode
    with PBColorMixin
    implements PBInheritedIntermediate {
  @override
  final originalRef;

  @override
  PrototypeNode prototypeNode;

  bool isBackgroundVisible = true;

  @override
  ChildrenStrategy childrenStrategy = TempChildrenStrategy('child');

  InheritedContainer(this.originalRef, Point topLeftCorner,
      Point bottomRightCorner, String name,
      {double alignX,
      double alignY,
      PBContext currentContext,
      Map borderInfo,
      this.isBackgroundVisible = true,
      PBIntermediateConstraints constraints})
      : super(topLeftCorner, bottomRightCorner, currentContext, name,
            UUID: originalRef.UUID ?? '', constraints: constraints) {
    if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
    generator = PBContainerGenerator();

    borderInfo ??= {};

    size = {
      'width': originalRef.boundaryRectangle.width,
      'height': originalRef.boundaryRectangle.height,
    };

    // have to save this in case it is overridden
    auxiliaryData.style = originalRef.style;

    if (originalRef.style != null && originalRef.style.fills.isNotEmpty) {
      for (var fill in originalRef.style.fills) {
        if (fill.isEnabled) {
          auxiliaryData.color = toHex(fill.color);
          // use the first one found.
          break;
        }
      }
    }

    auxiliaryData.borderInfo = borderInfo;

    assert(originalRef != null,
        'A null original reference was sent to an PBInheritedIntermediate Node');
  }

  @override
  void alignChild() {
    if (child != null) {
      /// Refactor to child.constraints != null
      if (child is! InheritedText) {
        // var left = (child.topLeftCorner.x - topLeftCorner.x).abs() ?? 0.0;
        // var right =
        //     (bottomRightCorner.x - child.bottomRightCorner.x).abs() ?? 0.0;
        // var top = (child.topLeftCorner.y - topLeftCorner.y).abs() ?? 0.0;
        // var bottom =
        //     (bottomRightCorner.y - child.bottomRightCorner.y).abs() ?? 0.0;
        // var padding = Padding('', child.constraints,
        //     left: left,
        //     right: right,
        //     top: top,
        //     bottom: bottom,
        //     topLeftCorner: topLeftCorner,
        //     bottomRightCorner: bottomRightCorner,
        //     currentContext: currentContext);
        // padding.addChild(child);
        // child = padding;
      }
    }
  }
}
