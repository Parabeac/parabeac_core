import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_prototype_enabled.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

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
  @JsonKey()
  String type = 'injected_container';

  bool pointValueWidth;
  bool pointValueHeight;

  bool showWidth;
  bool showHeight;

  @JsonKey(ignore: true)
  InjectedPadding padding;

  InjectedContainer(
    UUID,
    Rectangle3D frame, {
    String name,
    double alignX,
    double alignY,
    String color,
    this.prototypeNode,
    this.type,
    this.pointValueHeight = false,
    this.pointValueWidth = false,
    PBIntermediateConstraints constraints,
    this.showWidth = true,
    this.showHeight = true,
    this.padding,
  }) : super(
          UUID,
          frame,
          name,
          constraints: constraints,
        ) {
    generator = PBContainerGenerator();
    childrenStrategy = TempChildrenStrategy('child');
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$InjectedContainerFromJson(json);

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
          PBIntermediateNode parent, PBIntermediateTree tree) =>
      InjectedContainer.fromJson(json);
}

// Class for injected container to inject padding
class InjectedPadding {
  num left, right, top, bottom;
  InjectedPadding({
    this.left,
    this.right,
    this.top,
    this.bottom,
  });
}
