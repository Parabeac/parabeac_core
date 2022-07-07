import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:recase/recase.dart';

class ListViewCustom extends PBTag {
  @override
  String semanticName = '<custom>';
  ListViewCustom(String UUID, Rectangle3D<num> frame, String name)
      : super(UUID, frame, name) {
    this.generator = ListViewCustomGenerator();
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {
    // TODO: implement extractInformation
  }

  @override
  PBTag generatePluginNode(Rectangle3D<num> frame,
      PBIntermediateNode originalNode, PBIntermediateTree tree) {
    return ListViewCustom(
      originalNode.UUID,
      // null,
      originalNode.frame,
      originalNode.name.replaceAll('<simple_list_view>', '').pascalCase,
    );
  }
}

class ListViewCustomGenerator extends PBGenerator {
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    var bottomFrame = context.tree.findChild(
        source, 'Frame 4<listview_item2>', PBIntermediateStackLayout);
    var topFrame = context.tree.findChild(
        source, 'Frame 3<listview_item1>', PBIntermediateStackLayout);
    var spacing = (topFrame.frame.bottom - bottomFrame.frame.top).abs();
    print('buffer');
  }
}
