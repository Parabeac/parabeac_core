import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_align.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inherited_circle.g.dart';

@JsonSerializable(nullable: true)
class InheritedCircle extends PBVisualIntermediateNode
    implements PBInheritedIntermediate {
  @override
  final originalRef;

  @override
  @JsonKey(ignore: true)
  PrototypeNode prototypeNode;

  @override
  final Point bottomRightCorner;

  @override
  final Point topLeftCorner;

  @override
  String UUID;

  Map size;

  /// Used for setting the alignment of it's children
  @JsonKey(ignore: true)
  double alignX;
  @JsonKey(ignore: true)
  double alignY;

  Map borderInfo;

  @JsonKey(ignore: true)
  PBContext currentContext;

  String widgetType = 'CONTAINER';

  Map alignment;

  InheritedCircle(
      this.originalRef, this.bottomRightCorner, this.topLeftCorner, String name,
      {this.currentContext, this.alignX, this.alignY})
      : super(topLeftCorner, bottomRightCorner, currentContext, name) {
    if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
    generator = PBBitmapGenerator();

    UUID = originalRef.UUID;

    size = {
      'width': originalRef.boundaryRectangle.width,
      'height': originalRef.boundaryRectangle.height,
    };

    borderInfo = {};
    borderInfo['shape'] = 'circle';

    alignment = alignX != null && alignY != null
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

  Map<String, Object> toJson() => _$InheritedCircleToJson(this);

  factory InheritedCircle.fromJson(Map<String, Object> json) =>
      _$InheritedCircleFromJson(json);
}
