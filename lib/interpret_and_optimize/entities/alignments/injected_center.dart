import 'package:parabeac_core/generation/generators/visual-widgets/pb_center_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';

/// Represents the Center widget used in flutter to center its elements within
class InjectedCenter extends PBIntermediateNode
    implements PBInjectedIntermediate {
  InjectedCenter(
    String UUID,
    Rectangle3D<num> frame,
    String name, {
    constraints,
  }) : super(UUID, frame, name, constraints: constraints) {
    generator = PBCenterGenerator();
    childrenStrategy = OneChildStrategy('child');
    alignStrategy = NoAlignment();
  }
}
