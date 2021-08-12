import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_align.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:quick_log/quick_log.dart';

class PBAlignGenerator extends PBGenerator {
  var log = Logger('Align Generator');
  PBAlignGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext context) {
    if (source is InjectedAlign) {
      var buffer = StringBuffer();
      buffer.write('Align(');

      buffer.write(
          'alignment: Alignment(${source.alignX.toStringAsFixed(2)}, ${source.alignY.toStringAsFixed(2)}),');

      try {
        // source.child.currentContext = source.currentContext;
        buffer.write(
            'child: ${source.child.generator.generate(source.child, context)},');
      } catch (e, stackTrace) {
        MainInfo().sentry.captureException(
              exception: e,
              stackTrace: stackTrace,
            );
        log.error(e.toString());
      }

      buffer.write(')');
      return buffer.toString();
    }
  }
}
