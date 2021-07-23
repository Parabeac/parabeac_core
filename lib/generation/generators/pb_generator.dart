import 'package:parabeac_core/generation/generators/value_objects/template_strategy/inline_template_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/template_strategy/pb_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:quick_log/quick_log.dart';

abstract class PBGenerator {
  final String OBJECTID = 'UUID';
  static String MEDIAQUERY_HORIZONTAL_BOILERPLATE = 'MediaQuery.of(context).size.width';
  static String MEDIAQUERY_VERTICAL_BOILERPLATE = 'MediaQuery.of(context).size.height';

  Logger logger;

  ///The [TemplateStrategy] that is going to be used to generate the boilerplate code around the node.
  ///
  ///The `default` [TemplateStrategy] is going to be [InlineTemplateStrategy]
  TemplateStrategy templateStrategy;

  PBGenerator({TemplateStrategy strategy}) {
    templateStrategy = strategy;
    templateStrategy ??= InlineTemplateStrategy();
    logger = Logger(runtimeType.toString());
  }

  String generate(PBIntermediateNode source, PBContext context);
}
