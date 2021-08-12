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
  @JsonKey()
  String type = 'rectangle';

  @override
  @JsonKey(fromJson: PBIntermediateNode.sizeFromJson, name: 'boundaryRectangle')
  Map size;

  @override
  @JsonKey(ignore: true)
  Map<String, dynamic> originalRef;

  @override
  @JsonKey(ignore: true)
  List<PBIntermediateNode> get children => null;

  InheritedContainer(
    String UUID,
    Rectangle frame, {
    this.originalRef,
    Rectangle rectangle,
    String name,
    double alignX,
    double alignY,
    PBContext currentContext,
    this.isBackgroundVisible = true,
    this.size,
    this.prototypeNode,
  }) : super(
          UUID,
          rectangle,
          currentContext,
          name,
        ) {
    generator = PBContainerGenerator();
    childrenStrategy = TempChildrenStrategy('child');
    //TODO switch alignment to Padding alignment

    auxiliaryData.alignment = alignX != null && alignY != null
        ? {'alignX': alignX, 'alignY': alignY}
        : null;
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) {
    var container = _$InheritedContainerFromJson(json)
      // ..topLeftCorner = Point.topLeftFromJson(json)
      // ..bottomRightCorner = Point.bottomRightFromJson(json)
      ..originalRef = json;

    container.mapRawChildren(json);
    container.auxiliaryData.borderInfo.borderRadius = json['fixedRadius'];

    return container;
  }

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json) =>
      InheritedContainer.fromJson(json);
}
