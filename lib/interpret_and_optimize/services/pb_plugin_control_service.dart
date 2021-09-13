import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/layer_tuple.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:quick_log/quick_log.dart';

/// Plugin control service traverses the interediate node tree andl looks for nodes that are of type PBPluginNode.
/// When finding a plugin node, we call layoutInstruction(). This gives the PluginNdoe the ability to modify the relevant tree if needed.
/// Input: PBIntermediateTree
/// Output: PBIntermediateTree
class PBPluginControlService extends AITHandler {
  /// Constructor for PBPluginGenerationService, must include the root SketchNode
  PBPluginControlService();

  /// Builds and returns intermediate tree by breadth depth first.
  /// @return Returns the root node of the intermediate tree.
  Future<PBIntermediateTree> convertAndModifyPluginNodeTree(
      PBIntermediateTree tree, PBContext context) {
    // var originalRoot = tree.rootNode;
    // if (originalRoot == null) {
    //   logger.warning('generate() attempted to generate a non-existing tree.');
    //   return null;
    // }
    // var queue = <LayerTuple>[];
    // PBIntermediateNode rootIntermediateNode;
    // queue.add(LayerTuple([originalRoot], null));
    // while (queue.isNotEmpty) {
    //   var currentLayer = queue.removeAt(0);

    //   for (var currentIntermediateNode in currentLayer.nodeLayer) {
    //     if (currentIntermediateNode is PBEgg) {
    //       var layerToReplace =
    //           currentIntermediateNode.layoutInstruction(currentLayer.nodeLayer);
    //       if (layerToReplace == null && currentLayer.nodeLayer != null) {
    //         // print('Deleting an entire layer, was this on purpose?');
    //         logger.warning('Deleting an entire layer, was this on purpose?');

    //         currentLayer.nodeLayer = layerToReplace;
    //         break;
    //       }
    //       currentLayer.nodeLayer = layerToReplace;
    //     }

    //     // If we haven't assigned the rootIntermediateNode, this must be the first node, aka root node.
    //     rootIntermediateNode ??= currentLayer.nodeLayer[0];

    //     // Add updates regardless if nodes changed. ---- I think this forces the updates to the layer from layoutInstruction.
    //     if (currentLayer.parent is PBVisualIntermediateNode) {
    //       assert(currentLayer.nodeLayer.length <= 1,
    //           '[Plugin Control Service] We are going to end up deleting nodes here, something probably went wrong.');
    //       (currentLayer.parent as PBVisualIntermediateNode).replaceAttribute(context.tree,
    //           currentLayer.parent.attributeName, currentLayer.nodeLayer[0]);
    //     } else if (currentLayer.parent is PBLayoutIntermediateNode) {
    //       context.tree.replaceChildrenOf(currentLayer.parent, currentLayer.nodeLayer);
    //     }

    //     /// Add next depth layer to queue.
    //     if (currentIntermediateNode is PBVisualIntermediateNode &&
    //         currentIntermediateNode.child != null) {
    //       queue.add(LayerTuple(
    //           [currentIntermediateNode.child], currentIntermediateNode));
    //     } else if (currentIntermediateNode is PBLayoutIntermediateNode &&
    //         currentIntermediateNode.children != null) {
    //       queue.add(LayerTuple(
    //           currentIntermediateNode.children.cast<PBIntermediateNode>(),
    //           currentIntermediateNode));
    //     } else {
    //       assert(true,
    //           '[Plugin Control Service] We don\'t support class type ${currentIntermediateNode.runtimeType} for adding to the queue.');
    //     }
    //   }
    // }
    // tree.rootNode = rootIntermediateNode;
    return Future.value(tree);
  }

  @override
  Future<PBIntermediateTree> handleTree(
      PBContext context, PBIntermediateTree tree) {
    return convertAndModifyPluginNodeTree(tree, context);
  }
}
