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
  @JsonKey(
      fromJson: PrototypeNode.prototypeNodeFromJson, name: 'prototypeNodeUUID')
  PrototypeNode prototypeNode;

  @override
  @JsonKey()
  String type = 'group';

  @override
  @JsonKey(name: 'UUID')
  String UUID;

  @override
  @JsonKey(ignore: true)
  Point topLeftCorner;
  @override
  @JsonKey(ignore: true)
  Point bottomRightCorner;

  @override
  @JsonKey(fromJson: PBIntermediateNode.sizeFromJson, name: 'boundaryRectangle')
  Map size;

  @override
  PBContext currentContext;

  @override
  Map<String, dynamic> originalRef;

  TempGroupLayoutNode({
    this.originalRef,
    this.currentContext,
    String name,
    this.topLeftCorner,
    this.bottomRightCorner,
    this.UUID,
    this.prototypeNode,
    this.size,
  }) : super([], [], currentContext, name);

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

  static PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$TempGroupLayoutNodeFromJson(json)
        ..topLeftCorner = Point.topLeftFromJson(json)
        ..bottomRightCorner = Point.bottomRightFromJson(json)
        ..originalRef = json;

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json) =>
      (TempGroupLayoutNode.fromJson(json) as TempGroupLayoutNode)
        ..originalRef = json;
}
