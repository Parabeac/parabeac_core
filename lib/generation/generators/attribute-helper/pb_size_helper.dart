import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
import 'package:parabeac_core/generation/generators/value_objects/pb_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBSizeHelper extends PBAttributesHelper {
  PBSizeHelper() : super();

  @override
  String generate(PBIntermediateNode source) {
    final buffer = StringBuffer();
    var isSymbolMaster = source is PBSharedMasterNode;
    var isScaffoldBody =
        (source.generator.templateStrategy is StatefulTemplateStrategy);
    var body = source.size ?? {};
    double height = body['height'];
    double width = body['width'];
    var wString = 'width: ';
    var hString = 'height: ';

    //Add relative sizing if the widget has context
    if (isSymbolMaster || isScaffoldBody) {
      var screenWidth;
      var screenHeight;
      if (source.currentContext?.screenTopLeftCorner?.y != null &&
          source.currentContext?.screenBottomRightCorner?.y != null) {
        screenHeight = ((source.currentContext.screenTopLeftCorner.y) -
                (source.currentContext.screenBottomRightCorner.y))
            .abs();
        if (isSymbolMaster) {
          hString = 'height: constraints.maxHeight * ';
        } else {
          hString = 'height: MediaQuery.of(context).size.height * ';
        }
      }
      if (source.currentContext?.screenTopLeftCorner?.x != null &&
          source.currentContext?.screenBottomRightCorner?.x != null) {
        screenWidth = ((source.currentContext.screenTopLeftCorner.x) -
                (source.currentContext.screenBottomRightCorner.x))
            .abs();
        if (isSymbolMaster) {
          wString = 'width: constraints.maxWidth * ';
        } else {
          wString = 'width: MediaQuery.of(context).size.width * ';
        }
      }

      height = (height != null && screenHeight != null && screenHeight > 0.0)
          ? height / screenHeight
          : height;
      width = (width != null && screenWidth != null && screenWidth > 0.0)
          ? width / screenWidth
          : width;
    }

    if (width != null) {
      buffer.write(' ${wString}${width.toStringAsFixed(3)},');
    }
    if (height != null) {
      buffer.write('${hString}${height.toStringAsFixed(3)},');
    }

    return buffer.toString();
  }
}
