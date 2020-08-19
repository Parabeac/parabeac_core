import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/flexible.dart';
import 'package:quick_log/quick_log.dart';
import '../pb_flutter_generator.dart';
import '../pb_widget_manager.dart';

class PBFlexibleGenerator extends PBGenerator {
  var log = Logger('Flexible Generator');
  PBFlexibleGenerator(this.manager) : super('FLEXIBLE');

  final PBGenerationManager manager;

  @override
  String generate(PBIntermediateNode source) {
    if (source is Flexible) {
      var buffer = StringBuffer();
      buffer.write('Flexible(');
      buffer.write('flex: ${source.flex},');
      try {
        buffer.write(
            'child: ${manager.generate(source.child, type: source.builder_type ?? BUILDER_TYPE.BODY)},');
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
