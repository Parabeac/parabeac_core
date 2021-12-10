import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

import 'injected_container.dart';

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

  @JsonKey(ignore: true)
  InjectedPadding padding;

  InheritedContainer(
    String UUID,
    Rectangle3D frame, {
    this.originalRef,
    String name,
    double alignX,
    double alignY,
    this.isBackgroundVisible = true,
    this.prototypeNode,
    PBIntermediateConstraints constraints,
  }) : super(UUID, frame, name, constraints: constraints) {
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

    return container;
  }

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree) {
    return InheritedContainer.fromJson(json)..mapRawChildren(json, tree);
  }
}
