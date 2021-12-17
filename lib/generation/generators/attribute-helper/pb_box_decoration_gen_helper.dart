import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBBoxDecorationHelper extends PBAttributesHelper {
  PBBoxDecorationHelper() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    if (source is PBContainer) {
      final buffer = StringBuffer();
      buffer.write('decoration: BoxDecoration(');
      var borderInfo = source.auxiliaryData.borderInfo;
      if (source.auxiliaryData.color != null) {
        buffer.write(PBColorGenHelper().generate(source, generatorContext));
      }
      if (borderInfo != null) {
        if (borderInfo.shape == 'circle') {
          buffer.write('shape: BoxShape.circle,');
        } else if (borderInfo.borderRadius != null) {
          // Write border radius if it exists
          buffer.write(
              'borderRadius: BorderRadius.all(Radius.circular(${borderInfo.borderRadius})),');
          // Write border outline properties if applicable
          if (borderInfo.isBorderOutlineVisible &&
              (borderInfo.color != null || borderInfo.thickness != null)) {
            buffer.write('border: Border.all(');
            if (borderInfo.color != null) {
              buffer.write('color: Color(${borderInfo.color.toString()}),');
            }
            if (borderInfo.thickness != null) {
              buffer.write('width: ${borderInfo.thickness},');
            }
            buffer.write('),'); // end of Border.all(
          }
        }
      }
      buffer.write('),');

      return buffer.toString();
    }
    return '';
  }
}
