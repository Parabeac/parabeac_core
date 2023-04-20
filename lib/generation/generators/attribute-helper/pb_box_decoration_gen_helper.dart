import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBBoxDecorationHelper extends PBAttributesHelper {
  PBBoxDecorationHelper() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    final buffer = StringBuffer();

    buffer.write('decoration: BoxDecoration(');
    var borderInfo = source.auxiliaryData.borderInfo;
    var effectsInfo = source.auxiliaryData.effects;
    var colors = source.auxiliaryData.colors;
    if (colors != null && colors.isNotEmpty) {
      buffer.write(PBColorGenHelper().generate(source, generatorContext));
    }
    if (borderInfo != null) {
      if (borderInfo.borderRadius != null) {
        // Write border radius if it exists
        buffer.write(
            'borderRadius: BorderRadius.all(Radius.circular(${borderInfo.borderRadius})),');
      } else if (borderInfo.type == 'circle') {
        buffer.write('shape: BoxShape.circle,');
      }

      // Write border outline properties if applicable
      if (borderInfo.thickness > 0 && borderInfo.visible) {
        buffer.write('border: Border.all(');
        if (borderInfo.color != null) {
          buffer.write('color: Color(${borderInfo.color.toString()}),');
        }
        buffer.write('width: ${borderInfo.thickness},');
        buffer.write('),'); // end of Border.all(
      }
    }

    final shadows = effectsInfo
        .where((element) => element.type.toLowerCase().contains('shadow'))
        .toList();

    if (shadows.isNotEmpty) {
      buffer.write('boxShadow: [');

      for (final shadow in shadows) {
        buffer.write('''
            BoxShadow(
              ${PBColorGenHelper().getHexColor(shadow.color)}
              spreadRadius: ${shadow.radius},
              blurRadius: ${shadow.radius},
              offset: Offset(${shadow.offset['x']}, ${shadow.offset['y']}),
            ),
          ''');
      }

      buffer.write('],');
    }

    buffer.write('),');

    return buffer.toString();
  }
}
