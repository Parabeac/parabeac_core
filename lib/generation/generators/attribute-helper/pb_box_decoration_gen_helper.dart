import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBBoxDecorationHelper extends PBAttributesHelper {
  PBBoxDecorationHelper() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    if (source is PBContainer) {
      final buffer = StringBuffer();
      buffer.write('decoration: BoxDecoration(');
      var borderInfo = source.auxiliaryData.borderInfo;
      if (source.auxiliaryData.colors != null &&
          source.auxiliaryData.colors.isNotEmpty) {
        buffer.write(PBColorGenHelper().generate(source, generatorContext));
      }
      if (borderInfo != null) {
        if (borderInfo.cornerRadius != null) {
          // Write border radius if it exists
          buffer.write(
              'borderRadius: BorderRadius.all(Radius.circular(${borderInfo.cornerRadius})),');
        } else if (borderInfo.borders.isNotEmpty &&
            borderInfo.borders[0].type == 'circle') {
          buffer.write('shape: BoxShape.circle,');
        }

        // Write border outline properties if applicable
        if (borderInfo.borders.isNotEmpty &&
            borderInfo.strokeWeight != null &&
            borderInfo.strokeWeight > 0) {
          for (var i = 0; i < borderInfo.borders.length; i++) {
            //
            if (!borderInfo.borders[i].visible) {
              continue;
            } else {
              buffer.write('border: Border.all(');
              if (borderInfo.borders[i].color != null) {
                buffer.write(
                    'color: Color(${borderInfo.borders[i].color.toString()}),');
              }
              buffer.write('width: ${borderInfo.strokeWeight},');
              buffer.write('),'); // end of Border.all(
              break;
            }
          }
        }
      }
      buffer.write('),');

      return buffer.toString();
    }
    return '';
  }
}
