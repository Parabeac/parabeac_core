import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/stateful_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBScaffoldGenerator extends PBGenerator {
  PBScaffoldGenerator() : super(strategy: StatefulTemplateStrategy());

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    generatorContext.sizingContext = SizingValueContext.ScaleValue;
    var appBar = source.getAttributeNamed('appBar')?.attributeNode;
    var body = source.getAttributeNamed('body')?.attributeNode;
    var bottomNavBar =
        source.getAttributeNamed('bottomNavigationBar')?.attributeNode;
    if (source is InheritedScaffold) {
      var buffer = StringBuffer();
      buffer.write('Scaffold(\n');

      if (source.auxiliaryData.color != null) {
        var str = PBColorGenHelper().generate(source, generatorContext);
        buffer.write(str);
      }
      if (appBar != null) {
        buffer.write('appBar: ');
        generatorContext.sizingContext = SizingValueContext.PointValue;
        var appbarStr = appBar.generator.generate(appBar, generatorContext);

        buffer.write('$appbarStr,\n');
      }
      if (bottomNavBar != null) {
        buffer.write('bottomNavigationBar: ');
        generatorContext.sizingContext = SizingValueContext.PointValue;
        var navigationBar =
            bottomNavBar.generator.generate(bottomNavBar, generatorContext);
        buffer.write('$navigationBar, \n');
      }

      if (body != null) {
        // hack to pass screen width and height to the child
        buffer.write('body: ');
        var bodyStr = body.generator.generate(body, generatorContext);
        buffer.write('$bodyStr, \n');
      }
      buffer.write(')');
      return buffer.toString();
    } else {
      return '';
    }
  }
}
