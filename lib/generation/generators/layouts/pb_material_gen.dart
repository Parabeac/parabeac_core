import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/stateful_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_material.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBMaterialGenerator extends PBGenerator {
  PBMaterialGenerator() : super(strategy: StatefulTemplateStrategy());

  @override
  String generate(PBIntermediateNode source, PBContext context) {
    context.sizingContext = context.configuration.scaling
        ? SizingValueContext.ScaleValue
        : SizingValueContext.PointValue;
    var tree = context.tree;
    var body = source.getAttributeNamed(tree, 'child');
    if (source is InheritedMaterial) {
      var buffer = StringBuffer();
      buffer.write('Material(\n');

      if (source.auxiliaryData.color != null) {
        var str = PBColorGenHelper().generate(source, context);
        buffer.write(str);
      }
      if (body != null) {
        context.sizingContext = context.configuration.scaling
            ? SizingValueContext.ScaleValue
            : SizingValueContext.PointValue;

        buffer.write('child: ');

        var bodyStr = body.generator.generate(body, context);
        buffer.write('$bodyStr, \n');
      }
      buffer.write(')');
      return buffer.toString();
    } else {
      return '';
    }
  }
}
