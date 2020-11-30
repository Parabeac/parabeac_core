import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_align.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

import 'package:json_annotation/json_annotation.dart';

part 'injected_container.g.dart';

@JsonSerializable(nullable: true)
class InjectedContainer extends PBVisualIntermediateNode
    implements PBInjectedIntermediate {
  @JsonKey(ignore: true)
  PrototypeNode prototypeNode;

  InjectedContainer(
    Point bottomRightCorner,
    Point topLeftCorner,
    String name,
    String UUID, {
    double alignX,
    double alignY,
    String color,
    PBContext currentContext,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, name,
            UUID: UUID) {
    generator = PBContainerGenerator();

    if (currentContext.screenBottomRightCorner == null &&
        currentContext.screenTopLeftCorner == null) {
      this.currentContext.screenBottomRightCorner = bottomRightCorner;
      this.currentContext.screenTopLeftCorner = topLeftCorner;
    }

    size = {
      'width': (bottomRightCorner.x - topLeftCorner.x).abs(),
      'height': (bottomRightCorner.y - topLeftCorner.y).abs(),
    };

    auxillaryData.alignment = alignX != null && alignY != null
        ? {'alignX': alignX, 'alignY': alignY}
        : null;
  }

  @override
  void addChild(PBIntermediateNode node) {
    if (child is TempGroupLayoutNode) {
      child.addChild(node);
      return;
    }
    // If there's multiple children add a temp group so that layout service lays the children out.
    if (child != null) {
      var temp = TempGroupLayoutNode(null, currentContext, name);
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

  factory InjectedContainer.fromJson(Map<String, Object> json) =>
      _$InjectedContainerFromJson(json);
  Map<String, Object> toJson() => _$InjectedContainerToJson(this);
}
