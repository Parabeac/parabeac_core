import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/inline_template_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:quick_log/quick_log.dart';

import 'attribute-helper/pb_box_decoration_gen_helper.dart';

abstract class PBGenerator {
  final String OBJECTID = 'UUID';
  static String MEDIAQUERY_HORIZONTAL_BOILERPLATE =
      'MediaQuery.of(context).size.width';
  static String MEDIAQUERY_VERTICAL_BOILERPLATE =
      'MediaQuery.of(context).size.height';

  Logger logger;

  /// Chain of responsability restructure

  PBGenerator next;

  ///

  ///The [TemplateStrategy] that is going to be used to generate the boilerplate code around the node.
  ///
  ///The `default` [TemplateStrategy] is going to be [InlineTemplateStrategy]
  TemplateStrategy templateStrategy;

  PBGenerator({TemplateStrategy strategy, this.next}) {
    templateStrategy = strategy;
    templateStrategy ??= InlineTemplateStrategy();
    logger = Logger(runtimeType.toString());
  }

  String generate(PBIntermediateNode source, PBContext context);

  /// Method that wraps `this` with a `Container`.
  ///
  /// The container will also contain the [source]'s `styling` properties if applicable.
  /// The container will contain [source]'s `width` and `height` properties if [includeSize] is `true`.
  String containerWrapper(
    String body,
    PBIntermediateNode source,
    PBContext context, {
    bool includeSize = true,
  }) {
    var decoration = PBBoxDecorationHelper().generate(source, context);
    return '''
      Container(
        ${includeSize ? 'width: ${source.frame.width}, height: ${source.frame.height},' : ''}
        ${decoration.isEmpty || decoration.contains('BoxDecoration()') ? '' : '$decoration'}
        child: $body,
      )
    ''';
  }
}
