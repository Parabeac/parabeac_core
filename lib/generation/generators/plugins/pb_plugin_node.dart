import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';

import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

abstract class PBEgg extends PBVisualIntermediateNode {
  /// The allow list semantic name to detect this node.
  String semanticName;

  PBEgg(
    String UUID,
    Rectangle frame,
    String name,
  ) : super(
          UUID,
          frame,
          name,
        );

  /// Override this function if you want to make tree modification prior to the layout service.
  /// Be sure to return something or you will remove the node from the tree.
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) =>
      layer;

  PBEgg generatePluginNode(Rectangle frame, PBIntermediateNode originalNode,
      PBIntermediateTree tree);

  void extractInformation(PBIntermediateNode incomingNode);
}
