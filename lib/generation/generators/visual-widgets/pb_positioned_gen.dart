import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
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

      var multStringH = '';
      var multStringV = '';

      var top = source.top;
      var bottom = source.bottom;
      var left = source.left;
      var right = source.right;

      // TODO: this should be for all widgets once LayoutBuilder and constraints are used
      if (generatorContext.sizingContext ==
          SizingValueContext.LayoutBuilderValue) {
        if (source.currentContext?.screenTopLeftCorner?.x != null &&
            source.currentContext?.screenBottomRightCorner?.x != null) {
          var screenWidth = ((source.currentContext?.screenTopLeftCorner?.x) -
                  (source.currentContext?.screenBottomRightCorner?.x))
              .abs();
          multStringH = 'constraints.maxWidth * ';
          left = source.left / screenWidth;
          right = source.right / screenWidth;
        }

        if (source.currentContext?.screenTopLeftCorner?.y != null &&
            source.currentContext?.screenBottomRightCorner?.y != null) {
          var screenHeight = ((source.currentContext.screenTopLeftCorner.y) -
                  (source.currentContext.screenBottomRightCorner.y))
              .abs();
          multStringV = 'constraints.maxHeight * ';
          top = source.top / screenHeight;
          bottom = source.bottom / screenHeight;
        }
      }

      buffer.write('left: $multStringH${left.toStringAsFixed(3)}, right: $multStringH${right.toStringAsFixed(3)},');
      buffer.write('top: $multStringV${top.toStringAsFixed(3)}, bottom: $multStringV${bottom.toStringAsFixed(3)},');

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
