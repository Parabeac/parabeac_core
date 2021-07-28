import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBSizeHelper extends PBAttributesHelper {
  PBSizeHelper() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    if (source.currentContext == null) {
      print('Tried generating a size but couldn\'t retrieve [currentContext]');
      return '';
    }

    final buffer = StringBuffer();

    var body = source.size ?? {};
    double relativeHeight = body['height'];
    double relativeWidth = body['width'];

    //Add relative sizing if the widget has context
    var screenWidth;
    var screenHeight;
    if (source.currentContext.screenTopLeftCorner != null &&
        source.currentContext.screenBottomRightCorner != null) {
      screenWidth = ((source.currentContext.screenTopLeftCorner.x) -
              (source.currentContext.screenBottomRightCorner.x))
          .abs();
      screenHeight = ((source.currentContext.screenTopLeftCorner.y) -
              (source.currentContext.screenBottomRightCorner.y))
          .abs();
    }

    relativeHeight =
        (relativeHeight != null && screenHeight != null && screenHeight > 0.0)
            ? relativeHeight / screenHeight
            : relativeHeight;
    relativeWidth =
        (relativeWidth != null && screenWidth != null && screenWidth > 0.0)
            ? relativeWidth / screenWidth
            : relativeWidth;

    if (generatorContext.sizingContext == SizingValueContext.ScaleValue) {
      var height = source.constraints.fixedHeight != null
          ? body['height'].toStringAsFixed(3)
          : 'MediaQuery.of(context).size.height * ${relativeHeight.toStringAsFixed(3)}';
      var width = source.constraints.fixedWidth != null
          ? body['width'].toStringAsFixed(3)
          : 'MediaQuery.of(context).size.width * ${relativeWidth.toStringAsFixed(3)}';

      // buffer.write(
      //     'constraints: BoxConstraints(maxHeight: ${height}, maxWidth: ${width}),');
    } else if (generatorContext.sizingContext ==
        SizingValueContext.LayoutBuilderValue) {
      buffer.write(
          'width: constraints.maxWidth * ${relativeWidth.toStringAsFixed(3)},');
      buffer.write(
          'height: constraints.maxHeight * ${relativeHeight.toStringAsFixed(3)},');
    } else {
      relativeHeight = body['height'];
      relativeWidth = body['width'];
      if (relativeWidth != null) {
        buffer.write('width: ${relativeWidth.toStringAsFixed(3)},');
      }
      if (relativeHeight != null) {
        buffer.write('height: ${relativeHeight.toStringAsFixed(3)},');
      }
    }

    return buffer.toString();
  }
}
