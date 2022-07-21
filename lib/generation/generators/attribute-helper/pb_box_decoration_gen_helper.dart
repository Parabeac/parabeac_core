import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBBoxDecorationHelper extends PBAttributesHelper {
  PBBoxDecorationHelper() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    final buffer = StringBuffer();
    final headBuffer = StringBuffer();
    headBuffer.write('decoration: BoxDecoration(');
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

    if (effectsInfo != null &&
        effectsInfo.isNotEmpty &&
        effectsInfo.first.type.toLowerCase().contains('shadow')) {
      buffer.write('boxShadow: [');

      for (var effect in effectsInfo) {
        buffer.write('''
            BoxShadow(
              ${PBColorGenHelper().getHexColor(effect.color)}
              spreadRadius: ${effect.radius},
              blurRadius: ${effect.radius},
              offset: Offset(${effect.offset['x']}, ${effect.offset['y']}),
            ),
          ''');
      }

      buffer.write('],');
    }
    if (buffer.isEmpty) {
      return '';
    }

    headBuffer.write(buffer.toString());
    headBuffer.write('),');

    return headBuffer.toString();
  }
}
