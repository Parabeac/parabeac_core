import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

part 'temp_group_layout_node.g.dart';

@JsonSerializable(ignoreUnannotated: true, explicitToJson: true)

/// A temporary node that must be removed
class TempGroupLayoutNode extends PBLayoutIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey()
  List<PBIntermediateNode> children;

  @override
  @JsonKey(fromJson: PrototypeNode.prototypeNodeFromJson)
  PrototypeNode prototypeNode;

  @override
  @JsonKey()
  String type = 'temp_group';

  @override
  @JsonKey(name: 'UUID')
  String UUID;

  @override
  @JsonKey(fromJson: Point.topLeftFromJson)
  Point topLeftCorner;
  @override
  @JsonKey(fromJson: Point.bottomRightFromJson)
  Point bottomRightCorner;

  @override
  @JsonKey(fromJson: PBIntermediateNode.sizeFromJson)
  Map size;

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  TempGroupLayoutNode({
    this.currentContext,
    String name,
    this.topLeftCorner,
    this.bottomRightCorner,
    this.UUID,
    this.children,
    this.prototypeNode,
    this.size,
    this.type,
  }) : super([], [], currentContext, name) {
    // if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
    //   prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    // }
    this.topLeftCorner = topLeftCorner;
    this.bottomRightCorner = bottomRightCorner;
  }

  @override
  void addChild(PBIntermediateNode node) {
    addChildToLayout(node);
  }

  @override
  void alignChildren() {
    assert(false, 'Attempted to align children on class type [$runtimeType]');
    return null;
  }

  @override
  bool satisfyRules(
      PBIntermediateNode currentNode, PBIntermediateNode nextNode) {
    assert(false, 'Attempted to satisfyRules for class type [$runtimeType]');
    return null;
  }

  @override
  PBLayoutIntermediateNode generateLayout(List<PBIntermediateNode> children,
      PBContext currentContext, String name) {
    assert(false, 'Attempted to generateLayout for class type [$runtimeType]');
    return null;
  }

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$TempGroupLayoutNodeFromJson(json);
}
