import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_size_helper.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_shape_group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBShapeGroupGen extends PBGenerator {
  var _sizehelper;
  PBShapeGroupGen() : super() {
    _sizehelper = PBSizeHelper();
  }

  @override
  String generate(
      PBIntermediateNode source, GeneratorContext generatorContext) {
    if (source is InheritedShapeGroup) {
      var buffer = StringBuffer();
      buffer.write(
          'Image.asset(\'assets/images/${source.UUID}.png\', ${_sizehelper.generate(source)})');
      return buffer.toString();
    }
  }
}
