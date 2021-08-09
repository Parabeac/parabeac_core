import 'dart:math';

import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

part 'inherited_container.g.dart';

@JsonSerializable()
class InheritedContainer extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey(
      fromJson: PrototypeNode.prototypeNodeFromJson, name: 'prototypeNodeUUID')
  PrototypeNode prototypeNode;

  @JsonKey(defaultValue: true)
  bool isBackgroundVisible = true;

  @override
  @JsonKey(ignore: true)
  Point topLeftCorner;
  @override
  @JsonKey(ignore: true)
  Point bottomRightCorner;

   ChildrenStrategy childrenStrategy = TempChildrenStrategy('child');

  /// TODO: switch to padding
  @override
  AlignStrategy alignStrategy = NoAlignment();


  @override
  @JsonKey()
  String type = 'rectangle';

  @override
  String UUID;

  @override
  @JsonKey(fromJson: PBIntermediateNode.sizeFromJson, name: 'boundaryRectangle')
  Map size;

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  @override
  @JsonKey(ignore: true)
  Map<String, dynamic> originalRef;

  @override
  @JsonKey(ignore: true)
  List<PBIntermediateNode> get children => null;

  InheritedContainer({
    this.originalRef,
    this.topLeftCorner,
    this.bottomRightCorner,
    String name,
    double alignX,
    double alignY,
    this.currentContext,
    this.isBackgroundVisible = true,
    this.UUID,
    this.size,
    this.prototypeNode,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, name,
            UUID: UUID ?? '') {
    generator = PBContainerGenerator();

    auxiliaryData.alignment = alignX != null && alignY != null
        ? {'alignX': alignX, 'alignY': alignY}
        : null;
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) {
    var container = _$InheritedContainerFromJson(json)
      ..topLeftCorner = Point.topLeftFromJson(json)
      ..bottomRightCorner = Point.bottomRightFromJson(json)
      ..originalRef = json;

    container.mapRawChildren(json);
    container.auxiliaryData.borderInfo.borderRadius = json['fixedRadius'];

    return container;
  }

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json) =>
      InheritedContainer.fromJson(json);
}
