import 'dart:math';

import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/group/group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_color.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
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
  @JsonKey(ignore: true)
  Map<String, dynamic> originalRef;

  InheritedContainer(String UUID, Rectangle3D frame,
      {this.originalRef,
      String name,
      double alignX,
      double alignY,
      this.isBackgroundVisible = true,
      this.prototypeNode,
      PBIntermediateConstraints constraints})
      : super(UUID, frame, name, constraints: constraints) {
    generator = PBContainerGenerator();
    childrenStrategy = TempChildrenStrategy('child');
    //TODO switch alignment to Padding alignment

    auxiliaryData.alignment = alignX != null && alignY != null
        ? {'alignX': alignX, 'alignY': alignY}
        : null;
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) {
    var container = _$InheritedContainerFromJson(json)..originalRef = json;

    container.auxiliaryData.borderInfo.borderRadius = json['fixedRadius'];

    if (container.frame.height == 0) {
      container.frame = Rectangle3D(container.frame.left, container.frame.top,
          container.frame.width, 1.0, container.frame.z);
    }

    return container;
  }

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree) {
    return InheritedContainer.fromJson(json)..mapRawChildren(json, tree);
  }
}
