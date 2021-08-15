import 'package:parabeac_core/generation/generators/attribute-helper/pb_box_decoration_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_size_helper.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';

class PBContainerGenerator extends PBGenerator {
  String color;

  PBContainerGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext context) {
    var sourceChildren = context.tree.childrenOf(source);
    var buffer = StringBuffer();
    buffer.write('Container(');

    buffer.write(PBSizeHelper().generate(source, context));

    if (source.auxiliaryData.borderInfo != null) {
      buffer.write(PBBoxDecorationHelper().generate(source, context));
    } else {
      buffer.write(PBColorGenHelper().generate(source, context));
    }

    // if (source.auxiliaryData.alignment != null) {
    //   buffer.write(
    //       'alignment: Alignment(${(source.auxiliaryData.alignment['alignX'] as double).toStringAsFixed(2)}, ${(source.auxiliaryData.alignment['alignY'] as double).toStringAsFixed(2)}),');
    // }
    var child = sourceChildren.first;
    if (child != null) {
      child.frame = source.frame;
      // source.child.currentContext = source.currentContext;
      var statement = child != null
          ? 'child: ${child.generator.generate(child, context)}'
          : '';
      buffer.write(statement);
    }
    buffer.write(')');
    return buffer.toString();
  }
}
