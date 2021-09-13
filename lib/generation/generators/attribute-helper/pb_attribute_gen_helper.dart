import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

///For example, generating the size of Container or any other widget.
abstract class PBAttributesHelper extends PBGenerator {
  PBAttributesHelper() : super();
  @override
  String generate(PBIntermediateNode source, PBContext generatorContext);
}
