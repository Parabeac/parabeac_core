import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/input/sketch/helper/symbol_node_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBTextGen extends PBGenerator with PBColorMixin {
  PBTextGen() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    if (source is InheritedText) {
      source.currentContext.project.genProjectData
          .addDependencies('auto_size_text', '^2.1.0');

      source.managerData
          .addImport('package:auto_size_text/auto_size_text.dart');
      var buffer = StringBuffer();
      buffer.write('AutoSizeText(\n');
      var isTextParameter = source.isTextParameter;
      if (isTextParameter) {
        var text = source.text;
        buffer.write('$text, \n');
      } else {
        if (SN_UUIDtoVarName.containsKey('${source.UUID}_stringValue')) {
          buffer.write('${SN_UUIDtoVarName[source.UUID + '_stringValue']} ?? ');
        }
        buffer
            .write(('\'${source.text?.replaceAll('\n', ' ') ?? ''}\'') + ',\n');
      }
      buffer.write('style: ');
      if (SN_UUIDtoVarName.containsKey('${source.UUID}_textStyle')) {
        buffer.write(SN_UUIDtoVarName[source.UUID + '_textStyle'] + ' ?? ');
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
        if (findDefaultColor(source.auxiliaryData.color) == null) {
          buffer.write('color: Color(${source.auxiliaryData.color}),');
        } else {
          buffer
              .write('color: ${findDefaultColor(source.auxiliaryData.color)},');
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
}
