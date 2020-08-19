import 'package:parabeac_core/generation/generators/layouts/pb_layout_gen.dart';
import 'package:parabeac_core/generation/generators/pb_widget_manager.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/row.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import '../pb_flutter_generator.dart';

class PBRowGenerator extends PBLayoutGenerator {
  final PBGenerationManager manager;
  PBRowGenerator(this.manager) : super('ROW');

  @override
  String generate(PBIntermediateNode source) {
    if (source is PBIntermediateRowLayout) {
      var buffer = StringBuffer();
      var counter = 0;
      List<PBIntermediateNode> children = source.children;

      for (PBIntermediateNode child in children) {
        buffer.write(manager.generate(child,
            type: source.builder_type ?? BUILDER_TYPE.BODY));
        var trailing_comma = (counter + 1) == children.length ? '' : ',';
        buffer.write(trailing_comma);
        counter++;
      }

      return generateBodyBoilerplate(buffer.toString(),
          layoutName: 'Row',
          crossAxisAlignment: source.alignment['crossAxisAlignment']);
    }
  }
}
