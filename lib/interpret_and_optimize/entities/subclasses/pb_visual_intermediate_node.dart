import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pbdl_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

/// Represents a typical node that the end-user could see, it usually has properties such as size and color. It only contains a single child, unlike PBLayoutIntermediateNode that contains a set of children.
/// Superclass: PBIntermediateNode
abstract class PBVisualIntermediateNode extends PBIntermediateNode {
  // final String UUID;

  PBVisualIntermediateNode(Point topLeftCorner, Point bottomRightCorner,
      PBContext currentContext, String name,
      {String UUID, PBDLConstraints constraints})
      : super(topLeftCorner, bottomRightCorner, UUID, name,
            currentContext: currentContext, constraints: constraints);

  void alignChild();
}
