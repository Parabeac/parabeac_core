import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class InjectedExpanded extends PBVisualIntermediateNode {
  InjectedExpanded(String UUID, Rectangle3D<num> rectangle3d, String name)
      : super(UUID, rectangle3d, name) {
    generator = ExpandedGenerator();
  }
}

class ExpandedGenerator extends PBGenerator {
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    if (source is InjectedExpanded) {
      var children = context.tree.childrenOf(source);
      if (children.isNotEmpty) {
        var child = children.first;
        if (child != null) {
          return '''Expanded(
        child: ${child.generator.generate(child, context)}
      )''';
        }
      }
    }
    return '';
  }
}
