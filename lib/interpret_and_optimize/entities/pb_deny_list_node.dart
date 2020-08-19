import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

/// A node that should not be converted to intermediate.
class PBDenyListNode extends PBIntermediateNode {
  final String UUID;
  PBDenyListNode(
      Point topLeftCorner, Point bottomRightCorner, PBContext currentContext,
      {this.UUID})
      : super(topLeftCorner, bottomRightCorner, UUID,
            currentContext: currentContext);

  @override
  void addChild(PBIntermediateNode node) {
    // Unclear whether we should even go into the children if we run into a Deny List node.
    return;
  }
}
