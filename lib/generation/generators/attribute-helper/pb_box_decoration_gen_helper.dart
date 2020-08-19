import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';

class PBBoxDecorationHelper extends PBAttributesHelper {
  PBBoxDecorationHelper() : super('borderInfo');

  @override 
  String generate(PBIntermediateNode source) {
    if (source is InheritedContainer) {
      final buffer = StringBuffer();
      buffer.write('decoration: BoxDecoration(');
      var borderInfo = source.borderInfo;
      if (source.color != null) {
        buffer.write(PBColorGenHelper().generate(source));
      }
      if (borderInfo != null) {
        if (borderInfo['shape'] == 'circle') {
          buffer.write('shape: BoxShape.circle,');
        } else if (borderInfo['borderRadius'] != null) {
          buffer.write(
              'borderRadius: BorderRadius.all(Radius.circular(${borderInfo['borderRadius']})),');
          if (borderInfo['borderColorHex'] != null) {
            buffer.write(
                'border: Border.all(color: Color(${borderInfo['borderColorHex']}),),');
          }
        }
      }
      buffer.write('),');

      return buffer.toString();
    }
    return '';
  }
}
