import 'package:parabeac_core/generation/generators/attribute-helper/pb_box_decoration_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_size_helper.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

import '../pb_flutter_generator.dart';

class PBContainerGenerator extends PBGenerator {
  String color;

  PBContainerGenerator() : super('CONTAINER');

  @override
  String generate(PBIntermediateNode source) {
    var buffer = StringBuffer();
    buffer.write('Container(');

    buffer.write(PBSizeHelper().generate(source));

    if (source.borderInfo != null && source.borderInfo.isNotEmpty) {
      buffer.write(PBBoxDecorationHelper().generate(source));
    } else {
      buffer.write(PBColorGenHelper().generate(source));
    }

    if (source.alignment != null) {
      buffer.write(
          'alignment: Alignment(${(source.alignment['alignX'] as double).toStringAsFixed(2)}, ${(source.alignment['alignY'] as double).toStringAsFixed(2)}),');
    }

    if (source.child != null) {
      source.child.topLeftCorner =
          Point(source.topLeftCorner.x, source.topLeftCorner.y);
      source.child.bottomRightCorner =
          Point(source.bottomRightCorner.x, source.bottomRightCorner.y);
      var statement = source.child != null
          ? 'child: ${manager.generate(source.child, type: source.builder_type ?? BUILDER_TYPE.BODY)}'
          : '';
      buffer.write(statement);
    }
    buffer.write(')');
    return buffer.toString();
  }
}
