import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:recase/recase.dart';

class SliderCustom extends PBTag {
  String semanticName = '<slider>';
  SliderCustom(String UUID, Rectangle3D<num> frame, String name)
      : super(UUID, frame, name) {
    generator = SliderGenerator();
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {
    // TODO: implement extractInformation
  }

  @override
  PBTag generatePluginNode(Rectangle3D<num> frame,
      PBIntermediateNode originalNode, PBIntermediateTree tree) {
    return SliderCustom(
      null,
      originalNode.frame.copyWith(),
      originalNode.name.replaceAll('<slider>', '').pascalCase,
    );
  }
}

class SliderGenerator extends PBGenerator {
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    var slider = context.tree
        .findChild(source, 'Track<inactive_color>', InheritedContainer);
    print('buffer for breakpoint');
  }
}
