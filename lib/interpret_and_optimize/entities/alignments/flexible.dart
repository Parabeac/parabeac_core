import 'package:parabeac_core/generation/generators/visual-widgets/pb_flexible_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class Flexible extends PBVisualIntermediateNode {
  int flex;

  @override
  var currentContext;

  final String UUID;

  @override

  //TODO: Find a way to make currentContext required
  //without breaking the json serializable
  Flexible(
    this.UUID, {
    this.currentContext,
    child,
    this.flex,
    this.topLeftCorner,
    this.bottomRightCorner,
  }) : super(
          topLeftCorner,
          bottomRightCorner,
          currentContext,
          '',
          UUID: UUID,
        ) {
    generator = PBFlexibleGenerator();
    this.child = child;
  }

  Point topLeftCorner;

  Point bottomRightCorner;

  @override
  void addChild(PBIntermediateNode node) {
    assert(child == null, 'Tried adding another child to Flexible');
    child = node;
  }

  @override
  void alignChild() {}
}
