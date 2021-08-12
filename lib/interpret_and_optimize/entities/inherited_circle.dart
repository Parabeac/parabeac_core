import 'dart:math';

import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/intermediate_border_info.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

part 'inherited_circle.g.dart';

@JsonSerializable()
class InheritedCircle extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey(
      fromJson: PrototypeNode.prototypeNodeFromJson, name: 'prototypeNodeUUID')
  PrototypeNode prototypeNode;

  @override
  @JsonKey()
  String type = 'circle';
 
  @override
  @JsonKey(ignore: true)
  Map<String, dynamic> originalRef;

  InheritedCircle(
    String UUID,
    Rectangle frame, {
    this.originalRef,
    String name,
    Point alignX,
    Point alignY,
    this.prototypeNode,
  }) : super(
          UUID,
          frame,
          name,
        ) {
    generator = PBBitmapGenerator();
    childrenStrategy = TempChildrenStrategy('child');

    auxiliaryData.borderInfo = IntermediateBorderInfo();
    auxiliaryData.borderInfo.shape = 'circle';
    auxiliaryData.alignment = alignX != null && alignY != null
        ? {'alignX': alignX, 'alignY': alignY}
        : null;
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$InheritedCircleFromJson(json)
        ..originalRef = json;

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json) =>
      InheritedCircle.fromJson(json);
}
