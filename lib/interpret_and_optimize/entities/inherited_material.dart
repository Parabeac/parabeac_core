import 'package:parabeac_core/generation/generators/layouts/pb_material_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/group/frame_group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
import 'package:parabeac_core/tags/injected_app_bar.dart';
import 'package:parabeac_core/tags/injected_tab_bar.dart';

part 'inherited_material.g.dart';

@JsonSerializable()
class InheritedMaterial extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey(
      fromJson: PrototypeNode.prototypeNodeFromJson, name: 'prototypeNodeUUID')
  PrototypeNode prototypeNode;

  @JsonKey(defaultValue: false, name: 'isFlowHome')
  bool isHomeScreen = false;

  @override
  @JsonKey()
  String type = 'artboard';

  @override
  Map<String, dynamic> originalRef;

  InheritedMaterial(
    String UUID,
    Rectangle3D<num> frame,
    String name,
    this.originalRef, {
    this.isHomeScreen,
    this.prototypeNode,
    constraints,
  }) : super(UUID, frame, name, constraints: constraints) {
    generator = PBMaterialGenerator();
    childrenStrategy = MultipleChildStrategy('child');
  }

  @override
  void handleChildren(PBContext context) {
    var children = getAllAtrributeNamed(context.tree, 'child');

    // Top-most stack should have scaffold's frame to align children properly
    var groupAtt = FrameGroup(null, frame)
      ..name = '$name-Group'
      ..attributeName = 'child'
      ..parent = this;
    context.tree.addEdges(groupAtt, children.map((child) => child).toList());

    context.tree.replaceChildrenOf(
        this, [groupAtt]..removeWhere((element) => element == null));
  }

  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    return layer;
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) {
    var artboard = _$InheritedMaterialFromJson(json)..originalRef = json;
    return artboard;
  }

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
          PBIntermediateNode parent, PBIntermediateTree tree) =>
      InheritedMaterial.fromJson(json)..mapRawChildren(json, tree);
}
