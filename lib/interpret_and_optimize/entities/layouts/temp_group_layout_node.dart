import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

/// A temporary node that must be removed
class TempGroupLayoutNode extends PBLayoutIntermediateNode
    implements PBInheritedIntermediate {
  @override
  final originalRef;

  @override
  String get UUID => originalRef.UUID;

  TempGroupLayoutNode(this.originalRef, PBContext currentContext,
      {topLeftCorner, bottomRightCorner})
      : super([], [], currentContext) {
    this.topLeftCorner = topLeftCorner;
    this.bottomRightCorner = bottomRightCorner;
  }

  @override
  void addChild(PBIntermediateNode node) {
    addChildToLayout(node);
  }

  @override
  void alignChildren() {
    assert(false, 'Attempted to align children on class type [${runtimeType}]');
    return null;
  }

  @override
  PBLayoutIntermediateNode generateLayout(
      List<PBIntermediateNode> children, PBContext currentContext) {
    assert(
        false, 'Attempted to generateLayout for class type [${runtimeType}]');
    return null;
  }

  @override
  bool satisfyRules(
      PBIntermediateNode currentNode, PBIntermediateNode nextNode) {
    assert(false, 'Attempted to satisfyRules for class type [${runtimeType}]');
    return null;
  }
}
