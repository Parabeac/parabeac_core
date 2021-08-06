import 'dart:math';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';


/// A node that should not be converted to intermediate.
class PBDenyListNode extends PBIntermediateNode {
  @override
  ChildrenStrategy childrenStrategy = NoChildStrategy();

  PBDenyListNode(Point topLeftCorner, Point bottomRightCorner,
      PBContext currentContext, String name,
      {String UUID})
      : super(
          topLeftCorner,
          bottomRightCorner,
          UUID,
          name,
          currentContext: currentContext,
        );

}
