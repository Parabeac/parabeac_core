import 'package:parabeac_core/generation/generators/visual-widgets/pb_spacer_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class Spacer extends PBVisualIntermediateNode {
  int flex;

  @override
  ChildrenStrategy childrenStrategy = NoChildStrategy();


  Spacer(topLeftCorner, bottomRightCorner, String UUID,
      {this.flex, PBContext currentContext})
      : super(topLeftCorner, bottomRightCorner, currentContext, '',
            UUID: UUID) {
    generator = PBSpacerGenerator();
  }

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) => null;
}
