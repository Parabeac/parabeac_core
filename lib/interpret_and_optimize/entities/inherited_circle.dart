import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class InheritedCircle extends PBVisualIntermediateNode
    implements PBInheritedIntermediate {
  @override
  final originalRef;

  @override
  PrototypeNode prototypeNode;

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

  @override
  void alignChild() {
    var padding = Padding('', child.constraints,
        left: child.topLeftCorner.x - topLeftCorner.x,
        right: bottomRightCorner.x - child.bottomRightCorner.x,
        top: child.topLeftCorner.y - topLeftCorner.y,
        bottom: child.bottomRightCorner.y - bottomRightCorner.y,
        topLeftCorner: topLeftCorner,
        bottomRightCorner: bottomRightCorner,
        currentContext: currentContext);
    padding.addChild(child);
    child = padding;
  }
}
