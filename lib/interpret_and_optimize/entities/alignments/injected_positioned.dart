import 'package:parabeac_core/generation/generators/visual-widgets/pb_positioned_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class InjectedPositioned extends PBIntermediateNode
    implements PBInjectedIntermediate {
  PBContext currentContext;

  final String UUID;

  double top, bottom, left, right;

  InjectedPositioned(
    this.UUID, {
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.currentContext,
  }) : super(Point(0, 0), Point(0, 0), UUID, '',
            currentContext: currentContext) {
    top ??= 0;
    bottom ??= 0;
    left ??= 0;
    right ??= 0;
    generator = PBPositionedGenerator();
  }

  @override
  void addChild(PBIntermediateNode node) {
    assert(child == null,
        'Tried assigning multiple children to class [InjectedPositioned]');
    child = node;
  }
}
