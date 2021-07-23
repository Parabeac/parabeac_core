import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_align.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_prototype_enabled.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

import 'interfaces/pb_inherited_intermediate.dart';

part 'injected_container.g.dart';

@JsonSerializable()
class InjectedContainer extends PBVisualIntermediateNode
    implements
        PBInjectedIntermediate,
        PrototypeEnable,
        IntermediateNodeFactory {
  @override
  @JsonKey(fromJson: PrototypeNode.prototypeNodeFromJson)
  PrototypeNode prototypeNode;

  @override
  @JsonKey(fromJson: Point.topLeftFromJson)
  Point topLeftCorner;
  @override
  @JsonKey(fromJson: Point.bottomRightFromJson)
  Point bottomRightCorner;

  @override
  @JsonKey()
  String type = 'injected_container';

  @override
  String UUID;

  @override
  @JsonKey(fromJson: PBIntermediateNode.sizeFromJson)
  Map size;

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  InjectedContainer({
    this.bottomRightCorner,
    this.topLeftCorner,
    String name,
    this.UUID,
    double alignX,
    double alignY,
    String color,
    this.currentContext,
    this.prototypeNode,
    this.size,
    this.type,
  }) : super(
          topLeftCorner,
          bottomRightCorner,
          currentContext,
          name,
          UUID: UUID,
        ) {
    generator = PBContainerGenerator();

    // size = {
    //   'width': (bottomRightCorner.x - topLeftCorner.x).abs(),
    //   'height': (bottomRightCorner.y - topLeftCorner.y).abs(),
    // };

    auxiliaryData.alignment = alignX != null && alignY != null
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

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$InjectedContainerFromJson(json);
}
