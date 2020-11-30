import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class IntermediateVariation {
  String get UUID => node.UUID;
  PBIntermediateNode node;
  IntermediateVariation(this.node);
}
