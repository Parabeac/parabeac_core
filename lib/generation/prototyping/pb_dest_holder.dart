import 'package:parabeac_core/generation/prototyping/pb_prototype_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class PBDestHolder extends PBIntermediateNode {

  PrototypeNode pNode;

  PBDestHolder(
      Point topLeftCorner, Point bottomRightCorner, String UUID, this.pNode)
      : super(topLeftCorner, bottomRightCorner, UUID) {
    generator = PBPrototypeGenerator(pNode);
  }

  @override
  void addChild(PBIntermediateNode node) {
    assert(child == null,
        'Tried assigning multiple children to class [PBDestHolder]');
    child = node;
  }
}
