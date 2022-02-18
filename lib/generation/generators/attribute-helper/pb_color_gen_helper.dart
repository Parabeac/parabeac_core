import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_color.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/auxilary_data_helpers/intermediate_fill.dart';

class PBColorGenHelper extends PBAttributesHelper {
  PBColorGenHelper() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    if (source == null) {
      return '';
    }

    if (source.auxiliaryData.colors != null &&
        source.auxiliaryData.colors.first.type
            .toLowerCase()
            .contains('gradient')) {
      return _gradientColor(source.auxiliaryData.colors.first);
    }

    var color = source.auxiliaryData.color?.toString();
    if (color == null) {
      return '';
    }

    var defaultColor = findDefaultColor(color);

    // Check type of source to determine in which attribute to place the color
    switch (source.runtimeType) {
      case InheritedScaffold:
        return defaultColor != null
            ? 'backgroundColor: $defaultColor,\n'
            : 'backgroundColor: Color($color),\n';

      case InheritedContainer:
        if ((source as InheritedContainer).isBackgroundVisible) {
          return defaultColor != null
              ? 'color: $defaultColor,\n'
              : 'color: Color($color),\n';
        }
        return '';
      default:
        return defaultColor != null
            ? 'color: $defaultColor,\n'
            : 'color: Color($color),\n';
    }
  }

  /// Generate gradient for decoration box
  String _gradientColor(PBFill gradient) {
    var beginX = _roundNumber(gradient.gradientHandlePositions[0].x);
    var beginY = _roundNumber(gradient.gradientHandlePositions[0].y);
    var endX = _roundNumber(gradient.gradientHandlePositions[1].x);
    var endY = _roundNumber(gradient.gradientHandlePositions[1].y);

    return '''
    gradient: LinearGradient(
          begin: Alignment($beginX,$beginY),
          end: Alignment($endX,$endY), 
          colors: <Color>[
            Color(${gradient.gradientStops[0].color.toString()}),
            Color(${gradient.gradientStops[1].color.toString()}),
          ], 
          stops: [
            ${gradient.gradientStops[0].position},
            ${gradient.gradientStops[1].position},
          ],
          tileMode: TileMode.clamp, 
        ),
    ''';
  }

  num _roundNumber(num coordinate) {
    return (2 * coordinate) - 1;
  }

  /// Get String from Color
  String getHexColor(PBColor color) {
    if (color == null) {
      return '';
    }
    return 'color : Color(${color.toString()}),';
  }

  /// Finds default color based on common hex patterns.
  ///
  /// Returns `null` if no pattern was found
  String findDefaultColor(String hex) {
    switch (hex) {
      case '0xffffffff':
        return 'Colors.white';
      case '0xff000000':
        return 'Colors.black';
      default:
        return null;
    }
  }
}
