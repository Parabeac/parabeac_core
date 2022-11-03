import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_text_style_gen_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/override_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBTextGen extends PBGenerator with PBTextStyleGen {
  PBTextGen() : super();

  /// Maps PBDL decoration to Flutter decoration
  static final Map<String, String> _decorationMap = {
    'NONE': 'TextDecoration.none',
    'UNDERLINE': 'TextDecoration.underline',
    'STRIKETHROUGH': 'TextDecoration.lineThrough',
  };

  /// A cleaning map,
  /// The value on the left will be replaced by the value on the right
  /// They will be applied in order from top to bottom
  static final Map<dynamic, String> _replaceMap = {
    '\n': r'\n',
    '\'': '\\\'',
    '\$': '\\\$',
    RegExp(r'[\x00-\x1f]'): '',
  };

  /// Applies the replacement list to text
  static String cleanString(String text) {
    var newText = text;
    _replaceMap.forEach((target, replacement) {
      newText = newText.replaceAll(target, replacement);
    });
    return newText ?? '';
  }

  static String getDecoration(String decoration) {
    if (_decorationMap.containsKey(decoration)) {
      return _decorationMap[decoration];
    }
    return _decorationMap['NONE'];
  }

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

      buffer.write(getStyle(source, context) + ',');

      if (textStyle.textAlignHorizontal != null) {
        buffer.write(
            'textAlign: TextAlign.${textStyle.textAlignHorizontal.toLowerCase()},\n');
      }
      buffer.write('\n)');

      return buffer.toString();
    }
    return '';
  }
}
