import 'package:parabeac_core/generation/generators/visual-widgets/pb_spacer_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class Spacer extends PBVisualIntermediateNode {
  int flex;
  @override
  final String UUID;

  @override
  PBContext currentContext;

  @override
  ChildrenStrategy childrenStrategy = NoChildStrategy();

  Spacer(topLeftCorner, bottomRightCorner, this.UUID,
      {this.flex, this.currentContext})
      : super(topLeftCorner, bottomRightCorner, currentContext, '',
            UUID: UUID) {
    generator = PBSpacerGenerator();
  }

  @override
  void alignChild() {}
}
