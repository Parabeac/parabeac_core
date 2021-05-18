import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

abstract class PBLayoutGenerator extends PBGenerator {
  PBLayoutGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext);

  String generateBodyBoilerplate(String body,
      {String layoutName = 'Column',
      String crossAxisAlignment = '',
      String mainAxisAlignment = ''}) {
    layoutName ??= 'Column';
    crossAxisAlignment ??= '';
    mainAxisAlignment ??= '';
    var buffer = StringBuffer();
    layoutName[0].toUpperCase();
    buffer.write('''$layoutName(
      $crossAxisAlignment
      $mainAxisAlignment
    children:[
      $body
    ]
    )
    ''');
    return buffer.toString();
  }

  String generateAttributes(source) {
    var buffer = StringBuffer();
    if (source['alignment'] != null) {
      String crossAxisAlignment = source['alignment'];
      var items = crossAxisAlignment.split('.');
      buffer.write(
          'crossAxisAlignment: ${items[0]}.${items[1]?.toLowerCase() ?? 'start'}');
    }
    return buffer.toString();
  }
}
