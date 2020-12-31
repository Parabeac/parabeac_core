import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/spacer.dart';

class PBSpacerGenerator extends PBGenerator {
  PBSpacerGenerator() : super();

  @override
  String generate(
      PBIntermediateNode source, GeneratorContext generatorContext) {
    if (source is Spacer) {
      var buffer = StringBuffer();
      buffer.write('Spacer(');
      buffer.write('flex: ${source.flex},');
      buffer.write(')');
      return buffer.toString();
    }
  }
}
