import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_positioned.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:quick_log/quick_log.dart';

class PBPositionedGenerator extends PBGenerator {
  PBPositionedGenerator() : super();
  var log = Logger('Positioned Generator');

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    if (source is InjectedPositioned) {
      var buffer = StringBuffer();
      buffer.write('Positioned(');

      var multStringH = '';
      var multStringV = '';

      var valueHolder = PositionedValueHolder(
        top: source.valueHolder.top,
        bottom: source.valueHolder.bottom,
        left: source.valueHolder.left,
        right: source.valueHolder.right,
      );

      if (generatorContext.sizingContext ==
          SizingValueContext.MediaQueryValue) {
        multStringH = 'MediaQuery.of(context).size.width * ';
        multStringV = 'MediaQuery.of(context).size.height *';
        _calculateRelativeValues(source, valueHolder);
      } else if (generatorContext.sizingContext ==
          SizingValueContext.LayoutBuilderValue) {
        _calculateRelativeValues(source, valueHolder);
        multStringH = 'constraints.maxWidth * ';
        multStringV = 'constraints.maxHeight * ';
      }

      buffer.write(
          'left: $multStringH${valueHolder.left.toStringAsFixed(3)}, right: $multStringH${valueHolder.right.toStringAsFixed(3)},');
      buffer.write(
          'top: $multStringV${valueHolder.top.toStringAsFixed(3)}, bottom: $multStringV${valueHolder.bottom.toStringAsFixed(3)},');

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

  void _calculateRelativeValues(
      InjectedPositioned source, PositionedValueHolder holder) {
    if (source.currentContext?.screenTopLeftCorner?.x != null &&
        source.currentContext?.screenBottomRightCorner?.x != null) {
      var screenWidth = ((source.currentContext?.screenTopLeftCorner?.x) -
              (source.currentContext?.screenBottomRightCorner?.x))
          .abs();
      holder.left = source.valueHolder.left / screenWidth;
      holder.right = source.valueHolder.right / screenWidth;
    }

    if (source.currentContext?.screenTopLeftCorner?.y != null &&
        source.currentContext?.screenBottomRightCorner?.y != null) {
      var screenHeight = ((source.currentContext.screenTopLeftCorner.y) -
              (source.currentContext.screenBottomRightCorner.y))
          .abs();
      holder.top = source.valueHolder.top / screenHeight;
      holder.bottom = source.valueHolder.bottom / screenHeight;
    }
  }
}
