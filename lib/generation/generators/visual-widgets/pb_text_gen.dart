import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/input/sketch/helper/symbol_node_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBTextGen extends PBGenerator with PBColorMixin {
  PBTextGen() : super();

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
        if (source is PBSharedMasterNode) {
          var ovrName = SN_UUIDtoVarName[source.UUID + '_stringValue'];
          if (ovrName != null) {
            buffer.write('${ovrName} ?? ');
          }
        }
        buffer
            .write(('\'${source.text?.replaceAll('\n', ' ') ?? ''}\'') + ',\n');
      }
      buffer.write('style: ');
      if (source is PBSharedMasterNode) {
        var ovrName = SN_UUIDtoVarName[source.UUID + '_textStyle'];
        if (ovrName != null) {
          buffer.write('${ovrName} ?? ');
        }
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
