import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

/// Represents a typical node that the end-user could see, it usually has properties such as size and color. It only contains a single child, unlike PBLayoutIntermediateNode that contains a set of children.
/// Superclass: PBIntermediateNode
abstract class PBVisualIntermediateNode extends PBIntermediateNode {
  PBVisualIntermediateNode(
    String UUID,
    Rectangle3D rectangle3d,
    String name, {
    PBIntermediateConstraints constraints,
    IntermediateAuxiliaryData auxiliaryData,
  }) : super(
          UUID,
          rectangle3d,
          name,
          constraints: constraints,
          auxiliaryData: auxiliaryData,
        );
}
