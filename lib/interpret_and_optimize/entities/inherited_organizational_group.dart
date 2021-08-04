import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

import 'interfaces/pb_inherited_intermediate.dart';

class InheritedOrganizationalGroup extends PBLayoutIntermediateNode
    implements PBInheritedIntermediate {
  @override
  final originalRef;

  InheritedOrganizationalGroup(
    this.originalRef,
    PBContext currentContext,
    String name, {
    topLeftCorner,
    bottomRightCorner,
    PBIntermediateConstraints constraints,
  }) : super([], [], currentContext, name, constraints: constraints) {
    this.topLeftCorner = topLeftCorner;
    this.bottomRightCorner = bottomRightCorner;
  }

  @override
  PBLayoutIntermediateNode generateLayout(List<PBIntermediateNode> children,
      PBContext currentContext, String name) {
    assert(false, 'Attempted to generateLayout for class type [$runtimeType]');
    return null;
  }
}
