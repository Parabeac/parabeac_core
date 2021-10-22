import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/tags/injected_app_bar.dart';

class PBStackGenerator extends PBGenerator {
  PBStackGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext context) {
    if (source is PBIntermediateStackLayout) {
      var children = context.tree.childrenOf(source);
      var buffer = StringBuffer();

      buffer.write('Stack(');
      if (children.isNotEmpty) {
        buffer.write('\nchildren: [');
        for (var index = 0; index < children.length; index++) {
          var element =
              children[index].generator.generate(children[index], context);
          buffer.write(element);
          var endingChar = element != null && element.isEmpty ? '' : ',';
          buffer.write(endingChar);
        }
        buffer.write(']');
        buffer.write(')');
      }
      if (source.parent is InjectedAppbar) {
        return containerWrapper(buffer.toString(), source);
      }
      return buffer.toString();
    }
    return '';
  }

  String containerWrapper(String body, PBIntermediateNode source) {
    return '''
      Container(
        height: ${source.frame.height},
        width: ${source.frame.width},
        child: $body
      )
    ''';
  }
}
