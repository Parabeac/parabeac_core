import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/stateless_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_positioned.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:quick_log/quick_log.dart';

class PBPositionedGenerator extends PBGenerator {
  PBPositionedGenerator() : super();
  var log = Logger('Positioned Generator');

  @override
  String generate(
      PBIntermediateNode source, GeneratorContext generatorContext) {
    if (source is InjectedPositioned) {
      var buffer = StringBuffer();
      buffer.write('Positioned(');

      var hAlignValue = source.horizontalAlignValue;
      var vAlignValue = source.verticalAlignValue;
      var multStringH = '';
      var multStringV = '';

      // TODO: this should be for all widgets once LayoutBuilder and constraints are used
      if (source.generator.templateStrategy is StatelessTemplateStrategy) {
        if (source.currentContext?.screenTopLeftCorner?.x != null &&
            source.currentContext?.screenBottomRightCorner?.x != null) {
          var screenWidth = ((source.currentContext?.screenTopLeftCorner?.x) -
                  (source.currentContext?.screenBottomRightCorner?.x))
              .abs();
          multStringH = 'constraints.maxWidth * ';
          hAlignValue = hAlignValue / screenWidth;
        }

        if (source.currentContext?.screenTopLeftCorner?.y != null &&
            source.currentContext?.screenBottomRightCorner?.y != null) {
          var screenHeight = ((source.currentContext.screenTopLeftCorner.y) -
                  (source.currentContext.screenBottomRightCorner.y))
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
        source.child.currentContext = source.currentContext;
        buffer.write(
            'child: ${source.child.generator.generate(source.child, generatorContext)},');
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
