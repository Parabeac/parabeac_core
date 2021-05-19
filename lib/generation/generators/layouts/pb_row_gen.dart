import 'package:parabeac_core/generation/generators/layouts/pb_layout_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/row.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBRowGenerator extends PBLayoutGenerator {
  PBRowGenerator() : super();

  @override
  String generate(
      PBIntermediateNode source, PBContext generatorContext) {
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
