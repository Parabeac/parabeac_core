import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

abstract class PBGenHelper {
  String generate(PBIntermediateNode source);
  bool containsIntermediateNode(PBIntermediateNode widgetType);
  void registerIntemediateNode(PBIntermediateNode generator);
}
