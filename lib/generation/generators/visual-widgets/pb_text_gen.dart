import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/override_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBTextGen extends PBGenerator {
  PBTextGen() : super();

  static String cleanString(String text) =>
      text.replaceAll('\n', ' ')?.replaceAll('\'', '\\\'') ?? '';
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    if (source is InheritedText) {
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
      if (source.fontName != null) {
        buffer.write('fontFamily: \'${source.fontName}\',\n');
      }
      if (source.fontSize != null) {
        buffer.write('fontSize: ${source.fontSize.toString()},\n');
      }
      if (source.fontWeight != null) {
        buffer
            .write('fontWeight: FontWeight.${source.fontWeight.toString()},\n');
      }
      if (source.fontStyle != null) {
        buffer.write('fontStyle: FontStyle.${source.fontStyle},\n');
      }
      if (source.letterSpacing != null) {
        buffer.write('letterSpacing: ${source.letterSpacing},\n');
      }
      if (source.auxiliaryData.color != null) {
        buffer.write(PBColorGenHelper().generate(source, context));
      }

      buffer.write('),');
      if (source.textAlignment != null) {
        buffer.write('textAlign: TextAlign.${source.textAlignment},\n');
      }
      buffer.write('\n)');

      return buffer.toString();
    }
    return '';
  }
}
