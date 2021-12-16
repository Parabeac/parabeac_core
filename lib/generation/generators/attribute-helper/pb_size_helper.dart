import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
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

    if (source is InjectedContainer) {
      String heightString, widthString;
      final buffer = StringBuffer();

      double relativeHeight = source.frame.height;
      double relativeWidth = source.frame.width;

      //Add relative sizing if the widget has context
      var screenWidth;
      var screenHeight;
      if (context.screenFrame != null) {
        screenWidth = context.screenFrame.width;
        screenHeight = context.screenFrame.height;
      }

      if (context.sizingContext == SizingValueContext.ScaleValue) {
        // Size for scalevalue
        relativeHeight = (relativeHeight != null &&
                screenHeight != null &&
                screenHeight > 0.0)
            ? relativeHeight / screenHeight
            : relativeHeight;
        relativeWidth =
            (relativeWidth != null && screenWidth != null && screenWidth > 0.0)
                ? relativeWidth / screenWidth
                : relativeWidth;
        var height = source.constraints.fixedHeight
            ? source.frame.height.toStringAsFixed(3)
            : 'MediaQuery.of(context).size.height * ${relativeHeight.toStringAsFixed(3)}';
        var width = source.constraints.fixedWidth
            ? source.frame.width.toStringAsFixed(3)
            : 'MediaQuery.of(context).size.width * ${relativeWidth.toStringAsFixed(3)}';

        heightString = 'height: $height,';

        widthString = 'width: $width,';
      } else if (context.sizingContext ==
          SizingValueContext.LayoutBuilderValue) {
        // Size for LayoutBuilder
        widthString =
            'width: constraints.maxWidth * ${relativeWidth.toStringAsFixed(3)},';

        heightString =
            'height: constraints.maxHeight * ${relativeHeight.toStringAsFixed(3)},';
      } else {
        // Size for constants value
        widthString = 'width: ${relativeWidth.toStringAsFixed(3)},';

        heightString = 'height: ${relativeHeight.toStringAsFixed(3)},';
      }

      // Determine if it is going to show width and height
      if (relativeWidth != null && relativeWidth > 0 && source.showWidth) {
        buffer.write(widthString);
      }
      if (relativeHeight != null && relativeHeight > 0 && source.showHeight) {
        buffer.write(heightString);
      }

      return buffer.toString();
    }
    return '';
  }
}
