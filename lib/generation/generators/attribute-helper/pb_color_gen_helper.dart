import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_color.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBColorGenHelper extends PBAttributesHelper {
  PBColorGenHelper() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    if (source == null) {
      return '';
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
