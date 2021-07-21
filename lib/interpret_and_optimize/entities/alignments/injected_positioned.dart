import 'package:parabeac_core/generation/generators/visual-widgets/pb_positioned_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class InjectedPositioned extends PBIntermediateNode
    implements PBInjectedIntermediate {
  @override
  PBContext currentContext;

  @override
  final String UUID;

  final PositionedValueHolder valueHolder;
  
  @override
  ChildrenStrategy childrenStrategy = OneChildStrategy('child');

  InjectedPositioned(
    this.UUID, {
    this.valueHolder,
    this.currentContext,
    PBIntermediateConstraints constraints,
  }) : super(Point(0, 0), Point(0, 0), UUID, '',
            currentContext: currentContext, constraints: constraints) {
    generator = PBPositionedGenerator();
  }

}

/// Class to help us communicate and manipulate positioning values.
class PositionedValueHolder {
  double top;
  double bottom;
  double left;
  double right;

  PositionedValueHolder({
    this.top,
    this.bottom,
    this.left,
    this.right,
  }) {
    top ??= 0;
    bottom ??= 0;
    left ??= 0;
    right ??= 0;
  }
}
