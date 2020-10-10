import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

abstract class PBGenHelper {
  String generate(PBIntermediateNode source);
  bool containsIntermediateNode(PBIntermediateNode node);
  void registerIntemediateNode(PBIntermediateNode generator);
}
