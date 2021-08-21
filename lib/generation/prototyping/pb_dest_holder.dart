import 'package:parabeac_core/generation/prototyping/pb_prototype_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';

class PBDestHolder extends PBIntermediateNode {
  PrototypeNode pNode;

  PBDestHolder(
      String UUID, Rectangle3D frame, this.pNode)
      : super(UUID, frame, '') {
    generator = PBPrototypeGenerator(pNode);
    childrenStrategy = OneChildStrategy('child');
  }
}
