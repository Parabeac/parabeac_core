import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/stateful_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:quick_log/quick_log.dart';

class LayoutBuilderGenerator extends PBGenerator {
  LayoutBuilderGenerator(PBGenerator next)
      : super(strategy: StatefulTemplateStrategy(), next: next);

  var log = Logger('Layout Builder Generator');
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    var buffer = StringBuffer();
    buffer.write('LayoutBuilder( \n');
    buffer.write('  builder: (context, constraints) {\n');
    buffer.write('    return ');

    buffer.write(next.generate(source, context));

    buffer.write(';\n');
    buffer.write('}\n');
    buffer.write(')');

    return buffer.toString();
  }
}
