import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/pb_widget_manager.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:quick_log/quick_log.dart';

class PBSymbolInstanceGenerator extends PBGenerator {
  PBSymbolInstanceGenerator() : super('SYMBOL_INSTANCE');

  var log = Logger('Symbol Instance Generator');

  @override
  String generate(PBIntermediateNode source) {
    if (source is PBSharedInstanceIntermediateNode) {
      String method_signature = source.functionCallName;
      if (method_signature == null) {
        log.error(' Could not find master name on: $source');
        return 'Container(/** This Symbol was not found **/)';
      }
      method_signature = PBInputFormatter.formatLabel(method_signature,
          destroy_digits: false, space_to_underscore: false, isTitle: false);
      var buffer = StringBuffer();
      method_signature = method_signature[0].toLowerCase() +
          method_signature.substring(1, method_signature.length);

      buffer.write(method_signature);
      buffer.write('(context, ');
      // TODO: Add this once PCQ-03 is fixed
      // for (var param in source.sharedParamValues ?? []) {
      //   var text = param.value != null && param.value is String
      //       ? '\"${param.value}\"'
      //       : '${param.value}';
      //   if (text.isNotEmpty) {
      //     buffer.write((text + ','));
      //   }
      // }
      buffer.write(')');
      return buffer.toString();
    }
  }
}
