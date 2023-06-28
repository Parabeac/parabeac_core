import 'package:get_it/get_it.dart';
import 'package:parabeac_core/analytics/amplitude_analytics_service.dart';
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
          var element = children
              .elementAt(index)
              .generator
              .generate(children.elementAt(index), context);
          buffer.write(element);
          var endingChar = element != null && element.isEmpty ? '' : ',';
          buffer.write(endingChar);
        }
        buffer.write(']');
        buffer.write(')');
      }
      if (source.parent is InjectedAppbar) {
        return containerWrapper(buffer.toString(), source, context);
      }
      return buffer.toString();
    }
    return '';
  }
}
