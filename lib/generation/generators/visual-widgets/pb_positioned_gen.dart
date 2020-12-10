import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_positioned.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:quick_log/quick_log.dart';

import '../pb_flutter_generator.dart';

class PBPositionedGenerator extends PBGenerator {
  PBPositionedGenerator() : super();
  var log = Logger('Positioned Generator');

  @override
  String generate(PBIntermediateNode source) {
    if (source is InjectedPositioned) {
      var buffer = StringBuffer();
      buffer.write('Positioned(');

      double hAlignValue = source.horizontalAlignValue;
      double vAlignValue = source.verticalAlignValue;
      var multStringH = '';
      var multStringV = '';

      // TODO: this should be for all widgets once LayoutBuilder and constraints are used
      if (source.builder_type == BUILDER_TYPE.SYMBOL_MASTER) {
        if (source.currentContext?.screenTopLeftCorner?.x != null &&
            source.currentContext?.screenBottomRightCorner?.x != null) {
          double screenWidth = ((source.currentContext?.screenTopLeftCorner?.x
                      as double) -
                  (source.currentContext?.screenBottomRightCorner?.x as double))
              .abs();
          multStringH = 'constraints.maxWidth * ';
          hAlignValue = hAlignValue / screenWidth;
        }

        if (source.currentContext?.screenTopLeftCorner?.y != null &&
            source.currentContext?.screenBottomRightCorner?.y != null) {
          double screenHeight = ((source.currentContext.screenTopLeftCorner.y
                      as double) -
                  (source.currentContext.screenBottomRightCorner.y as double))
              .abs();
          multStringV = 'constraints.maxHeight * ';
          vAlignValue = vAlignValue / screenHeight;
        }
      }

      if (source.horizontalAlignValue != null) {
        buffer.write(
            '${source.horizontalAlignType}: ${multStringH}${hAlignValue},');
      }
      if (source.verticalAlignValue != null) {
        buffer.write(
            '${source.verticalAlignType} :${multStringV}${vAlignValue},');
      }

      try {
        buffer.write(
            'child: ${manager.generate(source.child, type: source.child.builder_type ?? BUILDER_TYPE.BODY)},');
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
