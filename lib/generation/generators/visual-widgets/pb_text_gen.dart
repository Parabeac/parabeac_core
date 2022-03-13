import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/override_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/auxilary_data_helpers/intermediate_effect.dart';

class PBTextGen extends PBGenerator {
  PBTextGen() : super();

  static String cleanString(String text) =>
      text.replaceAll('\n', ' ')?.replaceAll('\'', '\\\'') ?? '';
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    if (source is InheritedText) {
      var textStyle = source.auxiliaryData.intermediateTextStyle;
      var cleanText = cleanString(source.text);
      context.project.genProjectData.addDependencies('auto_size_text', '3.0.0');

      context.managerData
          .addImport(FlutterImport('auto_size_text.dart', 'auto_size_text'));
      var buffer = StringBuffer();
      buffer.write('AutoSizeText(\n');
      var isTextParameter = source.isTextParameter;
      if (isTextParameter) {
        var text = source.text;
        buffer.write('$text, \n');
      } else {
        var textOverride =
            OverrideHelper.getProperty(source.UUID, 'stringValue');
        if (textOverride != null) {
          buffer.write(textOverride.generateOverride());
        }
        buffer.write(('\'$cleanText\'') + ',\n');
      }
      buffer.write('style: ');
      var styleOverride = OverrideHelper.getProperty(source.UUID, 'textStyle');
      if (styleOverride != null) {
        buffer.write(styleOverride.generateOverride());
      }

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
        buffer.write('fontStyle: FontStyle.${textStyle.italics},\n');
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

      buffer.write('),');
      if (textStyle.textAlignHorizontal != null) {
        buffer.write(
            'textAlign: TextAlign.${textStyle.textAlignHorizontal.toLowerCase()},\n');
      }
      buffer.write('\n)');

      return buffer.toString();
    }
    return '';
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
