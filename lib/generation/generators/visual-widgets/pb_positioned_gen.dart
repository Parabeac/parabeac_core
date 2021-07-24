import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_positioned.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
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
      var buffer = StringBuffer('Positioned(');

      var boilerplate = _getBoilerplate(generatorContext.sizingContext);
      var xAxisBoilerplate = boilerplate.item1;
      var yAxisBoilerplate = boilerplate.item2;

      /// Since the generation phase is going to run multiple times, we are going to have to
      /// create a copy/clone of the [PositionedValueHolder] instead of assigning the values
      /// directly to the [source.valueHolder]. This would causse the [source.valueHolder.getRatioPercentage]
      /// to be applyed to ratios determine in a previoud generation phase run.
      /// This is going to be the case until we find a more suitable solution for the generation
      /// phase overall.
      var valueHolder = PositionedValueHolder(
          top: source.valueHolder.top,
          bottom: source.valueHolder.bottom,
          left: source.valueHolder.left,
          right: source.valueHolder.right,
          width: source.valueHolder.width,
          height: source.valueHolder.height);

      var positionalAtt = _getPositionalAtt(valueHolder, source.constraints);

      if (!(generatorContext.sizingContext == SizingValueContext.PointValue)) {
        /// [SizingValueContext.PointValue] is the only value in which dont change based on another scale/sizing

        var ratio = source.currentContext.getRatioPercentage;
        for (var attribute in positionalAtt) {
          if (!attribute.remainPointValue) {
            attribute.value =
                ratio(attribute.value, isHorizontal: attribute.isXAxis);
          }
        }
        // valueHolder.left = ratio(source.valueHolder.left, isHorizontal: true);
        // valueHolder.right = ratio(source.valueHolder.right, isHorizontal: true);
        // valueHolder.top = ratio(source.valueHolder.top, isHorizontal: false);
        // valueHolder.bottom =
        //     ratio(source.valueHolder.bottom, isHorizontal: false);

        // valueHolder.height = ratio(source.height, isHorizontal: false);
        // valueHolder.width = ratio(source.width, isHorizontal: true);
      }
      try {
        for (var attribute in positionalAtt) {
          buffer.write(
              '${attribute.attributeName}: ${_normalizeValue(attribute.isXAxis ? xAxisBoilerplate : yAxisBoilerplate, attribute)},');
        }
        // buffer.write(
        //     'left: ${_normalizeValue(xAxisBoilerplate, valueHolder.left)}, top: ${_normalizeValue(yAxisBoilerplate, valueHolder.top)},');
        // if (overrideChildDim) {
        //   buffer.write(
        //       'width: ${_normalizeValue(xAxisBoilerplate, valueHolder.width)}, height: ${_normalizeValue(yAxisBoilerplate, valueHolder.height)},');
        // } else {
        //   buffer.write(
        //       'right: ${_normalizeValue(xAxisBoilerplate, valueHolder.right)}, bottom: ${_normalizeValue(yAxisBoilerplate, valueHolder.bottom)},');
        // }

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
          '${PBGenerator.MEDIAQUERY_VERTICAL_BOILERPLATE} * ');
    }
    if (sizingValueContext == SizingValueContext.LayoutBuilderValue) {
      return Tuple2('constraints.maxWidth * ', 'constraints.maxHeight * ');
    }
    return Tuple2('', '');
  }

  /// Going to return the value without the [preValueStatement] if the [positionalValue]
  /// is equal to `0`.
  ///
  /// The main purpose of this is to prevent reduntant multiplication, for example,
  /// ```dart
  /// MediaQuery.of(context).size.height * 0.0
  /// ```
  /// Where it should be `0`.
  String _normalizeValue(String preValueStatement, _PositionedValue positionalValue) {
    var n = double.parse(positionalValue.value.toStringAsFixed(3));
    if (n == 0) {
      return '0';
    }
    if(positionalValue.remainPointValue){
      return '$n';
    }
    return '$preValueStatement$n';
  }

  List<_PositionedValue> _getPositionalAtt(
      PositionedValueHolder positionedValueHolder,
      PBIntermediateConstraints constrains) {
    var attributes = <_PositionedValue>[];
    var fixedWidth = constrains.fixedWidth != null;
    var fixedHeight = constrains.fixedHeight != null;
    if (!(constrains.pinLeft && constrains.pinRight)) {
      ///use [positionedValueHolder.left]
      attributes
          .add(_PositionedValue(positionedValueHolder.left, 'left', false));
      attributes.add(
          _PositionedValue(positionedValueHolder.width, 'width', fixedWidth));
    } else if (constrains.pinLeft && !constrains.pinRight) {
      ///use [positionedValueHolder.left]
      attributes
          .add(_PositionedValue(positionedValueHolder.left, 'left', true));
      attributes.add(
          _PositionedValue(positionedValueHolder.width, 'width', fixedWidth));
    } else if (!constrains.pinLeft && constrains.pinRight) {
      /// use [positionedValueHolder.right]
      attributes
          .add(_PositionedValue(positionedValueHolder.right, 'right', true));
      attributes.add(
          _PositionedValue(positionedValueHolder.width, 'width', fixedWidth));
    } else if (constrains.pinLeft && constrains.pinRight) {
      attributes
          .add(_PositionedValue(positionedValueHolder.left, 'left', true));
      attributes
          .add(_PositionedValue(positionedValueHolder.right, 'right', true));
    }

    ///Vertical constrains
    if (!(constrains.pinTop && constrains.pinBottom)) {
      attributes.add(
          _PositionedValue(positionedValueHolder.top, 'top', false, false));
      attributes.add(_PositionedValue(
          positionedValueHolder.height, 'height', fixedHeight, false));
    } else if (constrains.pinTop && !constrains.pinBottom) {
      attributes
          .add(_PositionedValue(positionedValueHolder.top, 'top', true, false));
      attributes.add(_PositionedValue(
          positionedValueHolder.height, 'height', fixedHeight, false));
    } else if (!constrains.pinTop && constrains.pinBottom) {
      /// use [positionedValueHolder.right]
      attributes.add(_PositionedValue(
          positionedValueHolder.bottom, 'bottom', true, false));
      attributes.add(_PositionedValue(
          positionedValueHolder.height, 'height', fixedHeight, false));
    } else if (constrains.pinTop && constrains.pinBottom) {
      attributes
          .add(_PositionedValue(positionedValueHolder.top, 'top', true, false));
      attributes.add(_PositionedValue(
          positionedValueHolder.bottom, 'bottom', true, false));
    }
    return attributes;
  }
}

class _PositionedValue {
  final String attributeName;
  final bool remainPointValue;
  final bool isXAxis;
  double value;

  _PositionedValue(this.value, this.attributeName, this.remainPointValue,
      [this.isXAxis = true]);
}
