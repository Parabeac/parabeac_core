import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_center.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBCenterGenerator extends PBGenerator {
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    var children = context.tree.childrenOf(source);
    if (!(source is InjectedCenter) || children.isEmpty) {
      return '';
    }
    if (children.length > 1) {
      logger.error(
          '$runtimeType contains more than a single child. Rendering only the first one');
    }
    return 'Center(\nchild: ${children.first.generator.generate(children.first, context)})';
  }
}
