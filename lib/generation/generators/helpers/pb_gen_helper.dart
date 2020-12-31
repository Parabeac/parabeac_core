import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

abstract class PBGenHelper {
  String generate(PBIntermediateNode source, GeneratorContext context);
  bool containsIntermediateNode(PBIntermediateNode node);
  void registerIntemediateNode(PBIntermediateNode generator);
}
