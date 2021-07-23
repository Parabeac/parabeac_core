import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_align.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inherited_container.g.dart';

@JsonSerializable()
class InheritedContainer extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey(fromJson: PrototypeNode.prototypeNodeFromJson)
  PrototypeNode prototypeNode;

  bool isBackgroundVisible = true;

  @override
  @JsonKey(fromJson: Point.topLeftFromJson)
  Point topLeftCorner;
  @override
  @JsonKey(fromJson: Point.bottomRightFromJson)
  Point bottomRightCorner;

  @override
  @JsonKey()
  String type = 'inherited_container';

  @override
  String UUID;

  @override
  @JsonKey(fromJson: PBIntermediateNode.sizeFromJson)
  Map size;

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  InheritedContainer({
    this.topLeftCorner,
    this.bottomRightCorner,
    String name,
    double alignX,
    double alignY,
    this.currentContext,
    Map borderInfo,
    this.isBackgroundVisible = true,
    this.type,
    this.UUID,
    this.size,
    this.prototypeNode,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, name,
            UUID: UUID ?? '') {
    // if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
    //   prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    // }
    generator = PBContainerGenerator();

    borderInfo ??= {};

    // size = {
    //   'width': originalRef.boundaryRectangle.width,
    //   'height': originalRef.boundaryRectangle.height,
    // };

    auxiliaryData.alignment = alignX != null && alignY != null
        ? {'alignX': alignX, 'alignY': alignY}
        : null;

    auxiliaryData.borderInfo = borderInfo;

    // assert(originalRef != null,
    //     'A null original reference was sent to an PBInheritedIntermediate Node');
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

  /// Should add positional info ONLY to parent node. This should only be sent here if the parent and child node is only one-to-one.
  ///
  /// alignCenterX/y = ((childCenter - parentCenter) / max) if > 0.5 subtract 0.5 if less than 0.5 multiply times -1
  @override
  void alignChild() {
    if (child != null) {
      var align =
          InjectedAlign(topLeftCorner, bottomRightCorner, currentContext, '');
      align.addChild(child);
      align.alignChild();
      child = align;
    }
  }

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$InheritedContainerFromJson(json);
}
