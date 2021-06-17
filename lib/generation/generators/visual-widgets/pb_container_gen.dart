import 'package:parabeac_core/generation/generators/attribute-helper/pb_box_decoration_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_size_helper.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class PBContainerGenerator extends PBGenerator {
  String color;

  PBContainerGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    var buffer = StringBuffer();
    buffer.write('Container(');

    buffer.write(PBSizeHelper().generate(source, generatorContext));

    if (source.auxiliaryData.borderInfo != null &&
        source.auxiliaryData.borderInfo.isNotEmpty) {
      buffer.write(PBBoxDecorationHelper().generate(source, generatorContext));
    } else {
      buffer.write(PBColorGenHelper().generate(source, generatorContext));
    }

    // if (source.auxiliaryData.alignment != null) {
    //   buffer.write(
    //       'alignment: Alignment(${(source.auxiliaryData.alignment['alignX'] as double).toStringAsFixed(2)}, ${(source.auxiliaryData.alignment['alignY'] as double).toStringAsFixed(2)}),');
    // }

    if (source.child != null) {
      source.child.topLeftCorner =
          Point(source.topLeftCorner.x, source.topLeftCorner.y);
      source.child.bottomRightCorner =
          Point(source.bottomRightCorner.x, source.bottomRightCorner.y);
      source.child.currentContext = source.currentContext;
      var statement = source.child != null
          ? 'child: ${source.child.generator.generate(source.child, generatorContext)}'
          : '';
      buffer.write(statement);
    }
    buffer.write(')');
    return buffer.toString();
  }
}
