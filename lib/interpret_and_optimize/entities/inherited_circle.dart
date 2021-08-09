<<<<<<< HEAD
import 'dart:math';

import 'package:parabeac_core/design_logic/design_node.dart';
=======
>>>>>>> origin/feat/pbdl-interpret
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/intermediate_border_info.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
<<<<<<< HEAD
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
=======
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
>>>>>>> origin/feat/pbdl-interpret

part 'inherited_circle.g.dart';

@JsonSerializable()
class InheritedCircle extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey(
      fromJson: PrototypeNode.prototypeNodeFromJson, name: 'prototypeNodeUUID')
  PrototypeNode prototypeNode;

  @override
  @JsonKey(ignore: true)
  Point topLeftCorner;
  @override
  @JsonKey(ignore: true)
  Point bottomRightCorner;

  @override
<<<<<<< HEAD
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
=======
  @JsonKey()
  String type = 'circle';
>>>>>>> origin/feat/pbdl-interpret

  @override
  String UUID;

  @override
  @JsonKey(fromJson: PBIntermediateNode.sizeFromJson, name: 'boundaryRectangle')
  Map size;

<<<<<<< HEAD
    auxiliaryData.borderInfo = {};
    auxiliaryData.borderInfo['shape'] = 'circle';
=======
  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  @override
  @JsonKey(ignore: true)
  Map<String, dynamic> originalRef;

  InheritedCircle({
    this.originalRef,
    this.bottomRightCorner,
    this.topLeftCorner,
    String name,
    this.currentContext,
    Point alignX,
    Point alignY,
    this.UUID,
    this.size,
    this.prototypeNode,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, name,
            UUID: UUID ?? '') {
    generator = PBBitmapGenerator();

    auxiliaryData.borderInfo = IntermediateBorderInfo();
    auxiliaryData.borderInfo.shape = 'circle';
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
      var temp = TempGroupLayoutNode(
        currentContext: currentContext,
        name: node.name,
      );
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
>>>>>>> origin/feat/pbdl-interpret
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$InheritedCircleFromJson(json)
        ..topLeftCorner = Point.topLeftFromJson(json)
        ..bottomRightCorner = Point.bottomRightFromJson(json)
        ..originalRef = json;

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json) =>
      InheritedCircle.fromJson(json);
}
