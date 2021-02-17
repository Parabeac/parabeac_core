import 'dart:mirrors';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/stateless_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import '../pb_generator.dart';

class PBPaddingGen extends PBGenerator {
  PBPaddingGen() : super();

  String relativePadding(
      TemplateStrategy strategy, bool isVertical, double value) {
    var fixedValue = value.toStringAsFixed(2);
    if (strategy is StatelessTemplateStrategy) {
      return 'constraints.max' +
          (isVertical ? 'Height' : 'Width') +
          ' * $fixedValue';
    }
    return 'MediaQuery.of(context).size.' +
        (isVertical ? 'height' : 'width') +
        ' * $fixedValue';
  }

  @override
  String generate(
      PBIntermediateNode source, GeneratorContext generatorContext) {
    if (!(source is Padding)) {
      return '';
    }
    final padding = source as Padding;
    var buffer = StringBuffer();
    buffer.write('Padding(');
    buffer.write('padding: EdgeInsets.only(');

    final paddingPositionsW = ['left', 'right'];
    final paddingPositionsH = ['bottom', 'top'];
    var reflectedPadding = reflect(padding);
    for (var position in paddingPositionsW) {
      var value = reflectedPadding.getField(Symbol(position)).reflectee;
      var isVertical = false;
      if (position == 'top' || position == 'bottom') {
        isVertical = true;
      }
      if (value != null) {
        buffer.write(
            '$position: ${relativePadding(source.generator.templateStrategy, isVertical, value)},');
      }
    }

    for (var position in paddingPositionsH) {
      var value = reflectedPadding.getField(Symbol(position)).reflectee;
      if (value != null) {
        buffer.write(
            '$position: ${relativePadding(source.generator.templateStrategy, true, value)},');
      }
    }

    buffer.write('),');

    if (source.child != null) {
      source.child.currentContext = source.currentContext;
      buffer.write(
          'child: ${source.child.generator.generate(source.child, generatorContext)}');
    }
    buffer.write(')');

    return buffer.toString();
  }
}
