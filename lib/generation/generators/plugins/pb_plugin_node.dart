import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';

import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

abstract class PBTag extends PBVisualIntermediateNode {
  /// The allow list semantic name to detect this node.
  String semanticName;

  PBTag(
    String UUID,
    Rectangle3D frame,
    String name, {
    PBIntermediateConstraints contraints,
    IntermediateAuxiliaryData auxiliaryData,
  }) : super(
          UUID,
          frame,
          name,
          constraints: contraints,
          auxiliaryData: auxiliaryData,
        );

  /// Override this function if you want to make tree modification prior to the layout service.
  /// Be sure to return something or you will remove the node from the tree.
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) =>
      layer;

  PBTag generatePluginNode(Rectangle3D frame, PBIntermediateNode originalNode,
      PBIntermediateTree tree);

  void extractInformation(PBIntermediateNode incomingNode);

  /// Handles `iNode` to convert into a [PBTag].
  ///
  /// Returns the [PBIntermediateNode] that should go into the [PBIntermediateTree]
  PBIntermediateNode handleIntermediateNode(
    PBIntermediateNode iNode,
    PBIntermediateNode parent,
    PBTag tag,
    PBIntermediateTree tree,
  ) {
    iNode.name = iNode.name.replaceAll(tag.semanticName, '');

    // If `iNode` is [PBSharedMasterNode] we need to place the [CustomTag] betweeen the
    // [PBSharedMasterNode] and the [PBSharedMasterNode]'s children. That is why we are returing
    // `iNode` at the end.
    if (iNode is PBSharedMasterNode) {
      tree.injectBetween(
          parent: iNode, child: tree.childrenOf(iNode).first, insertee: tag);

      return iNode;
    } else if (iNode is PBSharedInstanceIntermediateNode) {
      iNode.parent = parent;

      tree.replaceNode(iNode, tag);

      tree.addEdges(tag, [iNode]);

      return tag;
    } else {
      // [iNode] needs a parent and has not been added to the [tree] by [tree.addEdges]
      iNode.parent = parent;
      // If `iNode` has no children, it likely means we want to wrap `iNode` in [CustomEgg]
      if (tree.childrenOf(iNode).isEmpty || iNode is PBLayoutIntermediateNode) {
        /// Wrap `iNode` in `newTag` and make `newTag` child of `parent`.
        tree.removeEdges(iNode.parent, [iNode]);
        tree.addEdges(tag, [iNode]);
        tree.addEdges(parent, [tag]);
        return tag;
      }
      tree.replaceNode(iNode, tag, acceptChildren: true);

      return tag;
    }
  }
}
