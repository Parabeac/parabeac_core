import 'package:parabeac_core/generation/prototyping/pb_prototype_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class PBDestHolder extends PBIntermediateNode {
  PrototypeNode pNode;

  @override
  ChildrenStrategy childrenStrategy = OneChildStrategy('child');

  PBDestHolder(Point topLeftCorner, Point bottomRightCorner, String UUID,
      this.pNode, PBContext currentContext)
      : super(topLeftCorner, bottomRightCorner, UUID, '',
            currentContext: currentContext) {
    generator = PBPrototypeGenerator(pNode);
  }

}
