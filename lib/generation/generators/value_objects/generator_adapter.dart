import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

///An Adapter that allows custom string to be injected into a generator instead of a [PBIntermediateNode]
class StringGeneratorAdapter extends PBGenerator {
  final String overridenString;
  StringGeneratorAdapter(this.overridenString);
  @override
  String generate(PBIntermediateNode source) {
    overridenString;
  }
}
