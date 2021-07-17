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

      valueHolder.left =
          source.currentContext.getRatioPercentage(source.valueHolder.left);
      valueHolder.right =
          source.currentContext.getRatioPercentage(source.valueHolder.right);
      valueHolder.top = source.currentContext
          .getRatioPercentage(source.valueHolder.top, false);
      valueHolder.bottom = source.currentContext
          .getRatioPercentage(source.valueHolder.bottom, false);

      if (generatorContext.sizingContext == SizingValueContext.ScaleValue) {
        multStringH = 'MediaQuery.of(context).size.width * ';
        multStringV = 'MediaQuery.of(context).size.height *';
      } else if (generatorContext.sizingContext ==
          SizingValueContext.LayoutBuilderValue) {
        multStringH = 'constraints.maxWidth * ';
        multStringV = 'constraints.maxHeight * ';
      }

      buffer.write(
          'left: ${_normalizeValue(multStringH, valueHolder.left)}, right: ${_normalizeValue(multStringH, valueHolder.right)},');
      buffer.write(
          'top: ${_normalizeValue(multStringH, valueHolder.top)}, bottom: ${_normalizeValue(multStringH, valueHolder.bottom)},');

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

  /// Going to return the value without the [preValueStatement] if the [value]
  /// is equal to `0`.
  ///
  /// The main purpose of this is to prevent reduntant multiplication, for example,
  /// ```dart
  /// MediaQuery.of(context).size.height * 0.0
  /// ```
  /// Where it should be `0`.
  String _normalizeValue(String preValueStatement, double value) {
    if (value == 0) {
      return '0';
    }
    return '$preValueStatement${value.toStringAsFixed(3)}';
  }
}
