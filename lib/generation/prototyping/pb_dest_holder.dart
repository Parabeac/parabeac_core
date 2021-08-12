import 'package:parabeac_core/generation/prototyping/pb_prototype_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';

class PBDestHolder extends PBIntermediateNode {
  PrototypeNode pNode;

  @override
  ChildrenStrategy childrenStrategy = OneChildStrategy('child');

  PBDestHolder(
      String UUID, Rectangle frame, this.pNode, PBContext currentContext)
      : super(UUID, frame, '', currentContext: currentContext) {
    generator = PBPrototypeGenerator(pNode);
  }
}
