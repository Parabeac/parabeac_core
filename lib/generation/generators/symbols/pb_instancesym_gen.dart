import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/input/sketch/entities/style/shared_style.dart';
import 'package:parabeac_core/input/sketch/entities/style/text_style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:quick_log/quick_log.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:recase/recase.dart';

class PBSymbolInstanceGenerator extends PBGenerator {
  PBSymbolInstanceGenerator() : super();

  var log = Logger('Symbol Instance Generator');

  @override
  String generate(PBIntermediateNode source) {
    if (source is PBSharedInstanceIntermediateNode) {
      var method_signature = source.functionCallName;
      if (method_signature == null) {
        log.error(' Could not find master name on: $source');
        return 'Container(/** This Symbol was not found **/)';
      }
      method_signature = PBInputFormatter.formatLabel(method_signature,
          destroy_digits: false, space_to_underscore: false, isTitle: false);
      method_signature = method_signature.pascalCase;
      var buffer = StringBuffer();
      buffer.write('LayoutBuilder( \n');
      buffer.write('  builder: (context, constraints) {\n');
      buffer.write('    return ');
      buffer.write(method_signature);
      buffer.write('(');
      for (var param in source.sharedParamValues ?? []) {
        switch (param.type) {
          case PBSharedParameterValue:
            //PBSharedParameterValue pbspv = param;
            //switch (pbpsv.)
            // TODO, maybe this points to static instances? Like Styles.g.dart that will be eventually generated,
            // but what about prototype links?
            break;
          case InheritedBitmap:
            buffer.write('${param.name}: \"assets/${param.value["_ref"]}\",');
            break;
          case TextStyle:
            // hack to include import
            source.generator.manager.addImport(
                'package:${MainInfo().projectName}/document/shared_props.g.dart');
            buffer.write(
                '${param.name}: ${SharedStyle_UUIDToName[param.value] ?? "TextStyle()"},');
            break;
          default:
            buffer.write('${param.name}: \"${param.value}\",');
            break;
        }
      }
      // end of return function();
      buffer.write(');\n');
      // end of builder: (context, constraints) {
      buffer.write('}\n');
      // end of LayoutBuilder()
      buffer.write(')');
      return buffer.toString();
    }
  }
}
