import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

import '../pb_generator.dart';

class PBInjectedNode extends PBIntermediateNode {
  PBInjectedNode(
    Point topLeftCorner,
    Point bottomRightCorner,
    String UUID,
  ) : super(
          topLeftCorner,
          bottomRightCorner,
          UUID,
        );
  @override
  void addChild(PBIntermediateNode node) {
    // TODO: implement addChild
  }
}
