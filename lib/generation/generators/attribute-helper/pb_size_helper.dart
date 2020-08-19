import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import '../pb_flutter_generator.dart';

class PBSizeHelper extends PBAttributesHelper {
  PBSizeHelper() : super('size');

  @override
  String generate(PBIntermediateNode source) {
    final buffer = StringBuffer();

    Map body = source.size ?? {};
    double height = body['height'];
    double width = body['width'];
    //Add relative sizing if the widget has context
    if (source.builder_type != null &&
        source.builder_type == BUILDER_TYPE.SCAFFOLD_BODY) {
      var screenWidth;
      var screenHeight;
      if (source.currentContext?.screenTopLeftCorner?.y != null &&
          source.currentContext?.screenBottomRightCorner?.y != null) {
        screenHeight =
            ((source.currentContext.screenTopLeftCorner.y as double) -
                    (source.currentContext.screenBottomRightCorner.y as double))
                .abs();
      }
      if (source.currentContext?.screenTopLeftCorner?.x != null &&
          source.currentContext?.screenBottomRightCorner?.x != null) {
        screenWidth = ((source.currentContext?.screenTopLeftCorner?.x
                    as double) -
                (source.currentContext?.screenBottomRightCorner?.x as double))
            .abs();
      }

      height = (height != null && screenHeight != null && screenHeight != 0.0)
          ? height / screenHeight
          : height;
      width = (width != null && screenHeight != null && screenWidth != 0.0)
          ? width / screenWidth
          : width;

      if (width != null) {
        if (source.topLeftCorner.x != null &&
            source.bottomRightCorner.x != null) {
          buffer.write(
              'width : MediaQuery.of(context).size.width * ${width.toStringAsFixed(3)},');
        } else {
          buffer.write('width :${width.toStringAsFixed(2)},');
        }
      }
      if (height != null) {
        if (source.topLeftCorner.y != null &&
            source.bottomRightCorner.y != null) {
          buffer.write(
              ' height : MediaQuery.of(context).size.height * ${height.toStringAsFixed(3)},');
        } else {
          buffer.write('height : ${height.toStringAsFixed(2)},');
        }
      }
    } else {
      if (width != null) {
        buffer.write('width :${width.toStringAsFixed(2)},');
      }
      if (height != null) {
        buffer.write('height : ${height.toStringAsFixed(2)},');
      }
    }
    return buffer.toString();
  }
}
