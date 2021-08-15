import 'package:parabeac_core/generation/generators/layouts/pb_layout_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBColumnGenerator extends PBLayoutGenerator {
  PBColumnGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext context) {
    if (source is PBIntermediateColumnLayout) {
      var buffer = StringBuffer();
      var children = context.tree.childrenOf(source);
      buffer.write('Column(');
      if (children.isNotEmpty) {
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
        for (var index = 0; index < children.length; index++) {
          var element = children[index].generator
              .generate(children[index], context);
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
