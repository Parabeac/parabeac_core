import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import '../pb_flutter_generator.dart';

class PBStackGenerator extends PBGenerator {
  PBStackGenerator() : super();

  @override
  String generate(PBIntermediateNode source) {
    if (source is PBIntermediateStackLayout) {
      var buffer = StringBuffer();
      buffer.write('Stack(');
      if (source.children.isNotEmpty) {
        buffer.write('\nchildren: [');
        for (var index = 0; index < source.children.length; index++) {
          var element = manager.generate(source.children[index],
              type: source.children[index].builder_type ?? BUILDER_TYPE.BODY);
          buffer.write(element);
          var endingChar = element != null && element.isEmpty ? '' : ',';
          buffer.write(endingChar);
        }
        buffer.write(']');
        buffer.write(')');
      }
      return buffer.toString();
    }
    return '';
  }
}
