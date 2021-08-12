import 'package:parabeac_core/generation/generators/visual-widgets/pb_positioned_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';

class InjectedPositioned extends PBIntermediateNode
    implements PBInjectedIntermediate {
  final PositionedValueHolder valueHolder;

  @override
  ChildrenStrategy childrenStrategy = OneChildStrategy('child');

  InjectedPositioned(
    String UUID,
    Rectangle frame, {
    this.valueHolder,
    PBContext currentContext,
    PBIntermediateConstraints constraints,
  }) : super(UUID, frame, '',
            currentContext: currentContext, constraints: constraints) {
    generator = PBPositionedGenerator(overrideChildDim: true);
  }

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) => null;
}

/// Class to help us communicate and manipulate positioning values.
class PositionedValueHolder {
  double top;
  double bottom;
  double left;
  double right;

  double height;
  double width;

  PositionedValueHolder(
      {this.top, this.bottom, this.left, this.right, this.height, this.width}) {
    // top ??= 0;
    // bottom ??= 0;
    // left ??= 0;
    // right ??= 0;
  }
}
