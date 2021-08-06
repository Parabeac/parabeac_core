import 'dart:mirrors';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/stateless_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:tuple/tuple.dart';
import '../pb_generator.dart';

class PBPaddingGen extends PBGenerator {
  PBPaddingGen() : super();

  String relativePadding(
      TemplateStrategy strategy, double value, Tuple2 paddingPosition) {
    var fixedValue = value.toStringAsFixed(2);
    if (strategy is StatelessTemplateStrategy) {
      return 'constraints.max' +
          (paddingPosition.item1 == 'top' || paddingPosition.item1 == 'bottom'
              ? 'Height'
              : 'Width') +
          ' * $fixedValue';
    }
    if (paddingPosition.item2) {
      return '$fixedValue';
    } else {
      return 'MediaQuery.of(context).size.' +
          (paddingPosition.item1 == 'top' || paddingPosition.item1 == 'bottom'
              ? 'height'
              : 'width') +
          ' * $fixedValue';
    }
  }

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    if (generatorContext.sizingContext == SizingValueContext.AppBarChild) {
      source.child.currentContext = source.currentContext;
      return source.child.generator.generate(source.child, generatorContext);
    }
    if (!(source is Padding)) {
      return '';
    }
    final padding = source as Padding;
    var buffer = StringBuffer();
    buffer.write('Padding(');
    buffer.write('padding: EdgeInsets.only(');

    final paddingPositions = [
      Tuple2(
        'left',
        padding.childToParentConstraints.pinLeft,
      ),
      Tuple2(
        'right',
        padding.childToParentConstraints.pinRight,
      ),
      Tuple2(
        'bottom',
        padding.childToParentConstraints.pinBottom,
      ),
      Tuple2(
        'top',
        padding.childToParentConstraints.pinTop,
      )
    ];

    var reflectedPadding = reflect(padding);

    for (var position in paddingPositions) {
      if (reflectedPadding.getField(Symbol(position.item1)).reflectee != 0) {
        buffer.write(
            '${position.item1}: ${relativePadding(source.generator.templateStrategy, reflectedPadding.getField(Symbol(position.item1)).reflectee, position)},');
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
