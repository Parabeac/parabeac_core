import 'package:parabeac_core/generation/generators/layouts/pb_layout_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBColumnGenerator extends PBLayoutGenerator {
  PBColumnGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    if (source is PBIntermediateColumnLayout) {
      var buffer = StringBuffer();
      buffer.write('Column(');
      if (source.children.isNotEmpty) {
        var attributes = source.alignment;
        if (attributes != null && attributes.isNotEmpty) {
          if (attributes['crossAxisAlignment'] != null) {
            buffer.write(attributes['crossAxisAlignment']);
          }
          if (attributes['mainAxisAlignment'] != null) {
            buffer.write(attributes['mainAxisAlignment']);
          }
        }
        buffer.write('\nchildren: [');
        for (var index = 0; index < source.children.length; index++) {
          var element = source.children[index].generator
              .generate(source.children[index], generatorContext);
          buffer.write(element);
          var endingChar = element != null && element.isEmpty ? '' : ',';
          buffer.write(endingChar);
        }
        buffer.write(']');
        //generate the other attribtues
        buffer.write(')');
      }

      return buffer.toString();
    }
    return '';
  }
}
