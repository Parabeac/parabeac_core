import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_positioned.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:quick_log/quick_log.dart';

import '../pb_flutter_generator.dart';

class PBPositionedGenerator extends PBGenerator {
  PBPositionedGenerator() : super('POSITIONED');
  var log = Logger('Positioned Generator');

  @override
  String generate(PBIntermediateNode source) {
    if (source is InjectedPositioned) {
      var buffer = StringBuffer();
      buffer.write('Positioned(');

      if (source.horizontalAlignValue != null) {
        buffer.write(
            '${source.horizontalAlignType} :${source.horizontalAlignValue},');
      }
      if (source.verticalAlignValue != null) {
        buffer.write(
            '${source.verticalAlignType} :${source.verticalAlignValue},');
      }

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
