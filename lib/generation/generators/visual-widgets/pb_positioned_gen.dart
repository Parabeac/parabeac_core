import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_positioned.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:tuple/tuple.dart';

class PBPositionedGenerator extends PBGenerator {
  /// The Flutter Position class allows it to override the `height` and the
  /// `width` attribute of its `child` to affect the constrains in the y and x axis repectively.
  /// The Positioned class has to decide if it would have to override the `top`/`bottom` and `left`/`right`, or
  /// by [overrideChildDim] being `true`, the Positioned would use `top`/`height` and `left`/`width`.
  /// Reference: https://api.flutter.dev/flutter/widgets/Positioned-class.html
  bool overrideChildDim = false;

  PBPositionedGenerator({this.overrideChildDim = false}) : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    if (source is InjectedPositioned) {
      var buffer = StringBuffer();
      buffer.write('Positioned(');

      var boilerplate = _getBoilerplate(generatorContext.sizingContext);
      var xAxisBoilerplate = boilerplate.item1;
      var yAxisBoilerplate = boilerplate.item2;

      var valueHolder = source.valueHolder;

      if (!(generatorContext.sizingContext == SizingValueContext.PointValue)) {
        /// [SizingValueContext.PointValue] is the only value in which dont change based on another scale/sizing

        var ratio = source.currentContext.getRatioPercentage;
        valueHolder.left = ratio(source.valueHolder.left, true);
        valueHolder.right = ratio(source.valueHolder.right, true);
        valueHolder.top = ratio(source.valueHolder.top);
        valueHolder.bottom = ratio(source.valueHolder.bottom);

        valueHolder.height = ratio(source.height);
        valueHolder.width = ratio(source.width, true);
      }
      buffer.write(
          'left: ${_normalizeValue(xAxisBoilerplate, valueHolder.left)}, top: ${_normalizeValue(yAxisBoilerplate, valueHolder.top)},');
      if (overrideChildDim) {
        buffer.write(
            'width: ${_normalizeValue(xAxisBoilerplate, valueHolder.width)}, height: ${_normalizeValue(yAxisBoilerplate, valueHolder.height)},');
      } else {
        buffer.write(
            'right: ${_normalizeValue(xAxisBoilerplate, valueHolder.right)}, bottom: ${_normalizeValue(yAxisBoilerplate, valueHolder.bottom)},');
      }

      try {
        source.child.currentContext = source.currentContext;
        buffer.write(
            'child: ${source.child.generator.generate(source.child, generatorContext)},');
      } catch (e) {
        logger.error(e.toString());
        MainInfo().captureException(
          e,
        );
      }

      buffer.write(')');
      return buffer.toString();
    }
  }

  /// Getting the boilerplate needed to fill in the generation depending on the [sizingValueContext].
  Tuple2<String, String> _getBoilerplate(
      SizingValueContext sizingValueContext) {
    if (sizingValueContext == SizingValueContext.ScaleValue) {
      return Tuple2('${PBGenerator.MEDIAQUERY_HORIZONTAL_BOILERPLATE} * ',
          '${PBGenerator.MEDIAQUERY_VERTICAL_BOILERPLATE} *');
    }
    if (sizingValueContext == SizingValueContext.LayoutBuilderValue) {
      return Tuple2('constraints.maxWidth * ', 'constraints.maxHeight * ');
    }
    return Tuple2('', '');
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
    var n = double.parse(value.toStringAsFixed(3));
    if (n == 0) {
      return '0';
    }
    return '$preValueStatement$n';
  }
}
