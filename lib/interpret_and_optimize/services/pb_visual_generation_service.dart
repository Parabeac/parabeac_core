import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/sketch/services/positional_cleansing_service.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_deny_list_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/node_tuple.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_deny_list_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_plugin_list_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_generation_service.dart';

/// Takes a SketchNodeTree and begins generating PBNode interpretations. For each node, the node is going to pass through the PBSemanticInterpretationService which checks if the node should generate a specific PBIntermediateNode based on the semantics that it contains.
/// Input: SketchNodeTree
/// Output: PBIntermediateNodeTree
class PBVisualGenerationService implements PBGenerationService {
  /// The originalRoot sketch node.
  DesignNode originalRoot;

  PositionalCleansingService _positionalCleansingService;

  @override
  PBContext currentContext;

  /// Constructor for PBVisualGenerationService, must include the root SketchNode
  PBVisualGenerationService(originalRoot, {this.currentContext}) {
    _positionalCleansingService = PositionalCleansingService();
    this.originalRoot =
        _positionalCleansingService.eliminateOffset(originalRoot);
  }

  /// Builds and returns intermediate tree by breadth depth first.
  /// @return Returns the root node of the intermediate tree.
  Future<PBIntermediateNode> getIntermediateTree() async {
    if (originalRoot == null) {
      assert(true,
          '[VisualGenerationService] generate() attempted to generate a non-existing tree.');
    }
    PBPluginListHelper().initPlugins(currentContext);

    var queue = <NodeTuple>[];
    PBIntermediateNode rootIntermediateNode;
    queue.add(NodeTuple(originalRoot, null));
    while (queue.isNotEmpty) {
      var currentNode = queue.removeAt(0);
      if (currentNode.sketchNode.isVisible) {
        PBIntermediateNode result, original;
        // Check semantics
        result = PBDenyListHelper()
            .returnDenyListNodeIfExist(currentNode.sketchNode);
        if (result is PBDenyListNode) {
        } else {
          result = PBPluginListHelper()
              .returnAllowListNodeIfExists(currentNode.sketchNode);
          // Generate general intermediate node if still null.
          // needs to be assigned to [original], because [symbolMaster] needs to be registered to SymbolMaster
          original = await currentNode.sketchNode.interpretNode(currentContext);
          if (result == null ||
              original is PBSharedInstanceIntermediateNode ||
              original is PBSharedMasterNode) {
            result = original;
          }
          if (currentNode.convertedParent != null) {
            _addToParent(currentNode.convertedParent, result);
          }

          // If we haven't assigned the rootIntermediateNode, this must be the first node, aka root node.
          rootIntermediateNode ??= result;

          if (result != null) {
            // Add next depth to queue.
            if (currentNode.sketchNode is AbstractGroupLayer &&
                (currentNode.sketchNode as AbstractGroupLayer)
                    .layers
                    .isNotEmpty) {
              for (var child
                  in (currentNode.sketchNode as AbstractGroupLayer).layers) {
                queue.add(NodeTuple(child, result));
              }
            }
          }
        }
      }
    }
    return rootIntermediateNode;
  }

  void _addToParent(PBIntermediateNode parentNode,
          PBIntermediateNode convertedChildNode) =>
      parentNode.addChild(convertedChildNode);
}
