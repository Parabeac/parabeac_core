import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBTextGen extends PBGenerator {
  PBTextGen() : super('TEXT');

  @override
  String generate(PBIntermediateNode source) {
    if (source is InheritedText) {
      var buffer = StringBuffer();
      buffer.write('Text(\n');
      var isTextParameter = source.isTextParameter;
      if (isTextParameter) {
        var text = source.text;
        buffer.write('$text, \n');
      } else {
        buffer
            .write(('\'${source.text?.replaceAll('\n', ' ') ?? ''}\'') + ',\n');
      }
      buffer.write('style: TextStyle(\n');
      if (source.fontName != null) {
        buffer.write('fontFamily: \'${source.fontName}\',\n');
      }
      if (source.fontSize != null) {
        buffer.write('fontSize: ${source.fontSize.toString()},\n');
      }
      if (source.fontWeight != null) {
        buffer.write('fontWeight: FontWeight.${source.fontWeight.toString()},\n');
      }
      if (source.fontStyle != null) {
        buffer.write('fontStyle: FontStyle.${source.fontStyle},\n');
      }
      if (source.letterSpacing != null) {
        buffer.write('letterSpacing: ${source.letterSpacing},\n');
      }
      if (source.color != null) {
        if (findDefaultColor(source.color) == null) {
          buffer.write('color: Color(${source.color}),');
        } else {
          buffer.write('color: ${findDefaultColor(source.color)},');
        }
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

  String findDefaultColor(String hex) {
    switch (hex) {
      case '0xffffffff':
        return 'Colors.white';
        break;
      case '0xff000000':
        return 'Colors.black';
        break;
    }
    return null;
  }
}
