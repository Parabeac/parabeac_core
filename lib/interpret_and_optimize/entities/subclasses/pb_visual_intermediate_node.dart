import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

/// Represents a typical node that the end-user could see, it usually has properties such as size and color. It only contains a single child, unlike PBLayoutIntermediateNode that contains a set of children.
/// Superclass: PBIntermediateNode
abstract class PBVisualIntermediateNode extends PBIntermediateNode {
  String color;

  final String UUID;

  PBVisualIntermediateNode(
      Point topLeftCorner, Point bottomRightCorner, PBContext currentContext,
      {this.UUID})
      : super(topLeftCorner, bottomRightCorner, UUID,
            currentContext: currentContext);

  void alignChild();
}
