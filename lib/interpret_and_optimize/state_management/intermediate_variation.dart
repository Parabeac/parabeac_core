import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class IntermediateVariation {
  String uuid;
  PBIntermediateNode node;
  IntermediateVariation(this.uuid, this.node);
}
