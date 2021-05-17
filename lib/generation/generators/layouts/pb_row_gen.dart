import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/layouts/pb_layout_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/row.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBRowGenerator extends PBLayoutGenerator {
  PBRowGenerator() : super();

  @override
  String generate(
      PBIntermediateNode source, GeneratorContext generatorContext) {
    if (source is PBIntermediateRowLayout) {
      var buffer = StringBuffer();
      var counter = 0;
      var children = source.children;

      for (var child in children) {
        child.currentContext = source.currentContext;
        buffer.write(child.generator.generate(child, generatorContext));
        var trailing_comma = (counter + 1) == children.length ? '' : ',';
        buffer.write(trailing_comma);
        counter++;
      }

      return generateBodyBoilerplate(
        buffer.toString(),
        layoutName: 'Row',
        crossAxisAlignment: source.alignment['crossAxisAlignment'],
        mainAxisAlignment: source.alignment['mainAxisAlignment'],
      );
    }
  }
}
