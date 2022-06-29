import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBSizeHelper extends PBAttributesHelper {
  PBSizeHelper() : super();

  @override
  String generate(PBIntermediateNode source, PBContext context) {
    if (context == null) {
      print('Tried generating a size but couldn\'t retrieve [currentContext]');
      return '';
    }

    final buffer = StringBuffer();

    buffer.write(getSize(source, context, true));
    buffer.write(getSize(source, context, false));

    return buffer.toString();
  }

  String getSize(PBIntermediateNode source, PBContext context, bool isHeight) {
    var dimentionString = isHeight ? 'Height' : 'Width';
    var lowerCaseDimentionString = dimentionString.toLowerCase();
    String sizeString;
    final buffer = StringBuffer();

    double relativeSize = isHeight ? source.frame.height : source.frame.width;

    // Add relative sizing if the widget has context
    num screenSize;

    if (context.screenFrame != null) {
      screenSize =
          isHeight ? context.screenFrame.height : context.screenFrame.width;
    }

    if (context.sizingContext == SizingValueContext.ScaleValue) {
      // Size for scalevalue
      relativeSize =
          (relativeSize != null && screenSize != null && screenSize > 0.0)
              ? relativeSize / screenSize
              : relativeSize;

      var size = (isHeight
              ? source.constraints.fixedHeight
              : source.constraints.fixedWidth)
          ? (isHeight
              ? source.frame.height.toString()
              : source.frame.width.toString())
          : 'MediaQuery.of(context).size.$lowerCaseDimentionString * ${relativeSize.toString()}';

      sizeString = '$lowerCaseDimentionString: $size,';
    } else if (context.sizingContext == SizingValueContext.LayoutBuilderValue) {
      relativeSize = relativeSize / screenSize;

      // Size for LayoutBuilder
      sizeString =
          '$lowerCaseDimentionString: constraints.max$dimentionString * ${relativeSize.toString()},';
    } else if (context.sizingContext ==
        SizingValueContext.LayoutBuilderStatefulValue) {
      // Add case where width and/or height is static
      var isFixed = isHeight
          ? source.constraints.fixedHeight
          : source.constraints.fixedWidth;

      if (isFixed) {
        // Size for constants value
        sizeString = '$lowerCaseDimentionString: ${relativeSize.toString()},';
      } else {
        relativeSize = relativeSize / screenSize;

        // Size for LayoutBuilder
        sizeString =
            '$lowerCaseDimentionString: widget.constraints.max$dimentionString * ${relativeSize.toString()},';
      }
    } else {
      // Size for constants value
      sizeString = '$lowerCaseDimentionString: ${relativeSize.toString()},';
    }

    // Determine if it is going to show width and height
    var show = true;
    if (source is PBContainer) {
      show = isHeight ? source.showHeight : source.showWidth;
    }

    if (relativeSize != null && relativeSize > 0 && show) {
      buffer.write(sizeString);
    }

    return buffer.toString();
  }
}
