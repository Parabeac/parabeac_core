import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

abstract class PBGenHelper {
  String generate(PBIntermediateNode source, PBContext context);
  bool containsIntermediateNode(PBIntermediateNode node);
  void registerIntemediateNode(PBIntermediateNode generator);
}
