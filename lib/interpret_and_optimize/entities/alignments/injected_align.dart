import 'package:parabeac_core/generation/generators/visual-widgets/pb_align_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class InjectedAlign extends PBVisualIntermediateNode
    implements PBInjectedIntermediate {
  double alignX;
  double alignY;

  InjectedAlign(Point topLeftCorner, Point bottomRightCorner,
      PBContext currentContext, String name)
      : super(topLeftCorner, bottomRightCorner, currentContext, name) {
    generator = PBAlignGenerator();
  }

  @override
  void addChild(PBIntermediateNode node) {
    if (child is TempGroupLayoutNode) {
      child.addChild(node);
      return;
    }
    // If there's multiple children add a temp group so that layout service lays the children out.
    if (child != null) {
      var temp =
          TempGroupLayoutNode(currentContext: currentContext, name: node.name);
      temp.addChild(child);
      temp.addChild(node);
      child = temp;
    }
    child = node;
  }

  @override
  void alignChild() {
    var maxX = (topLeftCorner.x - bottomRightCorner.x).abs() -
        (child.bottomRightCorner.x - child.topLeftCorner.x).abs();
    var parentCenterX = (topLeftCorner.x + bottomRightCorner.x) / 2;
    var childCenterX = (child.topLeftCorner.x + child.bottomRightCorner.x) / 2;
    var alignmentX = 0.0;

    if (maxX != 0.0) {
      alignmentX = ((childCenterX - parentCenterX) / maxX) * 2;
    }

    var parentCenterY = (topLeftCorner.y + bottomRightCorner.y) / 2;
    var maxY = (topLeftCorner.y - bottomRightCorner.y).abs() -
        (child.bottomRightCorner.y - child.topLeftCorner.y).abs();
    var childCenterY = (child.topLeftCorner.y + child.bottomRightCorner.y) / 2;
    var alignmentY = ((childCenterY - parentCenterY) / maxY) * 2;

    if (maxY != 0.0) {
      alignmentY = ((childCenterY - parentCenterY) / maxY) * 2;
    }

    if (alignmentX.isNaN) {
      alignmentX = 0;
    }
    if (alignmentY.isNaN) {
      alignmentY = 0;
    }

    alignX = alignmentX.toDouble();
    alignY = alignmentY.toDouble();
  }

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) => null;
}
