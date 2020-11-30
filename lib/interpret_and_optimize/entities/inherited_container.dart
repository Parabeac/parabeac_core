import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_align.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class InheritedContainer extends PBVisualIntermediateNode
    with PBColorMixin
    implements PBInheritedIntermediate {
  @override
  final originalRef;

  @override
  PrototypeNode prototypeNode;

  bool isBackgroundVisible = true;

  InheritedContainer(
    this.originalRef,
    Point topLeftCorner,
    Point bottomRightCorner,
    String name, {
    double alignX,
    double alignY,
    PBContext currentContext,
    Map borderInfo,
    this.isBackgroundVisible = true,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, name,
            UUID: originalRef.UUID ?? '') {
    if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
    generator = PBContainerGenerator();

    borderInfo ??= {};

    size = {
      'width': originalRef.boundaryRectangle.width,
      'height': originalRef.boundaryRectangle.height,
    };

    if (originalRef.style != null && originalRef.style.fills.isNotEmpty) {
      for (var fill in originalRef.style.fills) {
        if (fill.isEnabled) {
          auxillaryData.color = toHex(fill.color);
        }
      }
    }
    auxillaryData.alignment = alignX != null && alignY != null
        ? {'alignX': alignX, 'alignY': alignY}
        : null;

    auxillaryData.borderInfo = borderInfo;

    assert(originalRef != null,
        'A null original reference was sent to an PBInheritedIntermediate Node');
  }

  @override
  void addChild(PBIntermediateNode node) {
    if (child is TempGroupLayoutNode) {
      child.addChild(node);
      return;
    }
    // If there's multiple children add a temp group so that layout service lays the children out.
    if (child != null) {
      var temp = TempGroupLayoutNode(null, currentContext, node.name);
      temp.addChild(child);
      temp.addChild(node);
      child = temp;
    }
    child = node;
  }

  /// Should add positional info ONLY to parent node. This should only be sent here if the parent and child node is only one-to-one.
  ///
  /// alignCenterX/y = ((childCenter - parentCenter) / max) if > 0.5 subtract 0.5 if less than 0.5 multiply times -1
  @override
  void alignChild() {
    var align =
        InjectedAlign(topLeftCorner, bottomRightCorner, currentContext, '');
    align.addChild(child);
    align.alignChild();
    child = align;
  }
}
