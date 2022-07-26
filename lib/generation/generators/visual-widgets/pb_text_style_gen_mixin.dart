import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/auxilary_data_helpers/intermediate_effect.dart';

mixin PBTextStyleGen {
  String getStyle(InheritedText source, PBContext context) {
    var textStyle = source.auxiliaryData.intermediateTextStyle;
    var buffer = StringBuffer();
    buffer.write('TextStyle(\n');
    if (textStyle.fontFamily != null) {
      buffer.write('fontFamily: \'${textStyle.fontFamily}\',\n');
    }
    if (textStyle.fontSize != null) {
      buffer.write('fontSize: ${textStyle.fontSize.toString()},\n');
    }
    if (textStyle.fontWeight != null) {
      buffer.write(
          'fontWeight: FontWeight.w${textStyle.fontWeight.toString()},\n');
    }
    if (textStyle.italics != null) {
      buffer.write(
          'fontStyle: ${(textStyle.italics ?? false) ? 'FontStyle.italic' : 'FontStyle.normal'},\n');
    }
    if (textStyle.letterSpacing != null) {
      buffer.write('letterSpacing: ${textStyle.letterSpacing},\n');
    }
    if (source.auxiliaryData.color != null) {
      buffer.write(PBColorGenHelper().generate(source, context));
    }

    if (source.auxiliaryData.effects != null) {
      buffer.write(_getEffects(source.auxiliaryData.effects));
    }

    buffer.write(')');

    return buffer.toString();
  }

  String _getEffects(List<PBEffect> effects) {
    var shadows = '';
    effects.forEach((effect) {
      if (effect.visible && effect.type.toLowerCase().contains('shadow')) {
        shadows += '''
        Shadow(
          ${PBColorGenHelper().getHexColor(effect.color)}
          offset: Offset(${effect.offset['x']}, ${effect.offset['y']}),
          blurRadius: ${effect.radius},
        ),
        ''';
      }
    });
    if (shadows.isNotEmpty) {
      return '''
      shadows: [
        $shadows
      ],
      ''';
    }
    return '';
  }
}
