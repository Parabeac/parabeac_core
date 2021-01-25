import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBSizeHelper extends PBAttributesHelper {
  PBSizeHelper() : super();

  @override
  String generate(
      PBIntermediateNode source, GeneratorContext generatorContext) {
    if (source.currentContext == null) {
      print('Tried generating a size but couldn\'t retrieve [currentContext]');
      return '';
    }

    final buffer = StringBuffer();

    var body = source.size ?? {};
    double height = body['height'];
    double width = body['width'];
    var wString = 'width: ';
    var hString = 'height: ';

    //Add relative sizing if the widget has context
    var screenWidth = ((source.currentContext.screenTopLeftCorner.x) -
            (source.currentContext.screenBottomRightCorner.x))
        .abs();
    var screenHeight = ((source.currentContext.screenTopLeftCorner.y) -
            (source.currentContext.screenBottomRightCorner.y))
        .abs();

    height = (height != null && screenHeight != null && screenHeight > 0.0)
        ? height / screenHeight
        : height;
    width = (width != null && screenWidth != null && screenWidth > 0.0)
        ? width / screenWidth
        : width;

    if (generatorContext.sizingContext == SizingValueContext.MediaQueryValue) {
      buffer.write(
          'width: MediaQuery.of(context).size.width * ${width.toStringAsFixed(3)},');
      buffer.write(
          'height: MediaQuery.of(context).size.height * ${height.toStringAsFixed(3)},');
    } else if (generatorContext.sizingContext ==
        SizingValueContext.LayoutBuilderValue) {
      buffer
          .write('width: constraints.maxWidth * ${width.toStringAsFixed(3)},');
      buffer.write(
          'height: constraints.maxHeight * ${height.toStringAsFixed(3)},');
    } else {
      height = body['height'];
      width = body['width'];
      if (width != null) {
        buffer.write('width: ${width.toStringAsFixed(3)},');
      }
      if (height != null) {
        buffer.write('height: ${height.toStringAsFixed(3)},');
      }
    }

    return buffer.toString();
  }
}
