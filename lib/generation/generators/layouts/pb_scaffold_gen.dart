import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/stateful_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBScaffoldGenerator extends PBGenerator {
  PBScaffoldGenerator() : super(strategy: StatefulTemplateStrategy());

  @override
  String generate(
      PBIntermediateNode source, GeneratorContext generatorContext) {
    generatorContext.sizingContext = SizingValueContext.MediaQueryValue;
    if (source is InheritedScaffold) {
      var buffer = StringBuffer();
      buffer.write('Scaffold(\n');

      if (source.auxiliaryData.color != null) {
        var str = PBColorGenHelper().generate(source, generatorContext);
        buffer.write(str);
      }
      if (source.navbar != null) {
        buffer.write('appBar: ');
        var newGeneratorContext =
            GeneratorContext(sizingContext: SizingValueContext.PointValue);
        var appbar = source.navbar.generator
            .generate(source.navbar, newGeneratorContext);

        buffer.write('$appbar,\n');
      }
      if (source.tabbar != null) {
        buffer.write('bottomNavigationBar: ');
        var newGeneratorContext =
            GeneratorContext(sizingContext: SizingValueContext.PointValue);
        var navigationBar = source.tabbar.generator
            .generate(source.tabbar, newGeneratorContext);
        buffer.write('$navigationBar, \n');
      }

      if (source.child != null) {
        // hack to pass screen width and height to the child
        buffer.write('body: ');
        var body =
            source.child.generator.generate(source.child, generatorContext);
        buffer.write('$body, \n');
      }
      buffer.write(')');
      return buffer.toString();
    } else {
      return '';
    }
  }
}
