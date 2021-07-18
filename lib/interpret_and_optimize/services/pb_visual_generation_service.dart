import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/group_node.dart';
import 'package:parabeac_core/design_logic/pb_shared_instance_design_node.dart';
import 'package:parabeac_core/design_logic/pb_shared_master_node.dart';
import 'package:parabeac_core/generation/prototyping/pb_dest_holder.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/input/sketch/services/positional_cleansing_service.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_deny_list_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/node_tuple.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_deny_list_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_plugin_list_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_state_management_helper.dart';

/// Takes a SketchNodeTree and begins generating PBNode interpretations. For each node, the node is going to pass through the PBSemanticInterpretationService which checks if the node should generate a specific PBIntermediateNode based on the semantics that it contains.
/// Input: SketchNodeTree
/// Output: PBIntermediateNodeTree
class PBVisualGenerationService{

  PositionalCleansingService _positionalCleansingService;

  PBStateManagementHelper smHelper;

  /// Boolean that is `true` if the [VisualGenerationService]
  /// is currently processing a state management node
  bool ignoreStates = false;

  PBVisualGenerationService() {
    _positionalCleansingService = PositionalCleansingService();
    smHelper = PBStateManagementHelper();
  }

  DesignNode _positionalOffsetAdjustment(DesignNode designNode){
    // Only do positional cleansing for non-state nodes, since those nodes
    // have already been through this service
    if(designNode != null && !ignoreStates){
      return _positionalCleansingService.eliminateOffset(designNode);
    }
    return designNode;
  }

  /// Builds and returns intermediate tree by breadth depth first.
  /// @return Returns the root node of the intermediate tree.
  Future<PBIntermediateTree> getIntermediateTree(DesignNode originalRoot, PBContext currentContext) async {
    if (originalRoot == null) {
      return Future.value(null);
    }
    var tree = PBIntermediateTree(originalRoot.name);
    originalRoot = _positionalOffsetAdjustment(originalRoot);

    PBPluginListHelper().initPlugins(currentContext);

    var queue = <NodeTuple>[];
    PBIntermediateNode rootIntermediateNode;
    queue.add(NodeTuple(originalRoot, null));
    while (queue.isNotEmpty) {
      var currentNode = queue.removeAt(0);

      if (currentNode.designNode?.isVisible ?? true) {
        PBIntermediateNode result;
        // Check semantics
        result = PBDenyListHelper()
            .returnDenyListNodeIfExist(currentNode.designNode);

        if (result is PBDenyListNode) {
        } else {
          result = PBPluginListHelper()
              .returnAllowListNodeIfExists(currentNode.designNode);

          /// Generate general intermediate node if still null.
          /// needs to be assigned to [original], because [symbolMaster] needs to be registered to SymbolMaster

          if (result == null ||
              currentNode.designNode is PBSharedInstanceDesignNode ||
              currentNode.designNode is PBSharedMasterDesignNode) {
            result = await currentNode.designNode.interpretNode(currentContext);
          }

          // Interpret state management node
          if (!ignoreStates &&
              smHelper.isValidStateNode(result.name) &&
              (currentNode.designNode.name !=
                      currentNode.convertedParent?.name ??
                  true) &&
              result is PBSharedMasterNode) {
            if (smHelper.isDefaultNode(result)) {
              smHelper.interpretStateManagementNode(result);
            } else {
              smHelper.interpretStateManagementNode(result);
              continue;
            }
          }

          if (currentNode.convertedParent != null) {
            _addToParent(currentNode.convertedParent, result);
          }

          // If we haven't assigned the rootIntermediateNode, this must be the first node, aka root node.
          rootIntermediateNode ??= result;
          if(rootIntermediateNode != null){
            _extractScreenSize(rootIntermediateNode, currentContext);
          }
           

          if (result != null) {
            // Add next depth to queue.
            if (currentNode.designNode is GroupNode &&
                (currentNode.designNode as GroupNode).children != null &&
                (currentNode.designNode as GroupNode).children.isNotEmpty) {
              for (var child
                  in (currentNode.designNode as GroupNode).children) {
                queue.add(NodeTuple(child, result));
              }
            }
          }
        }
      }
    }
    // TODO: This should be replaced for something more optimal or done in some other class
    if (originalRoot.prototypeNodeUUID != null) {
      var prototypeNode = PrototypeNode(originalRoot.prototypeNodeUUID);
      var destHolder = PBDestHolder(
          rootIntermediateNode.topLeftCorner,
          rootIntermediateNode.bottomRightCorner,
          rootIntermediateNode.UUID,
          prototypeNode,
          rootIntermediateNode.currentContext);
      destHolder.addChild(rootIntermediateNode);
      tree.rootNode = destHolder;
      return Future.value(tree);
    }
    tree.rootNode = rootIntermediateNode;
    return Future.value(tree);
  }

  ///Sets the size of the UI element.
  ///
  ///We are assuming that since the [rootIntermediateNode] contains all of the nodes
  ///then it should represent the biggest screen size that encapsulates the entire UI elements.
  void _extractScreenSize(PBIntermediateNode rootIntermediateNode, PBContext currentContext) {
    if ((currentContext.screenBottomRightCorner == null &&
            currentContext.screenTopLeftCorner == null) ||
        (currentContext.screenBottomRightCorner !=
                rootIntermediateNode.bottomRightCorner ||
            currentContext.screenTopLeftCorner !=
                rootIntermediateNode.bottomRightCorner)) {
      currentContext.screenBottomRightCorner =
          rootIntermediateNode.bottomRightCorner;
      currentContext.screenTopLeftCorner = rootIntermediateNode.topLeftCorner;
    }
  }

  void _addToParent(PBIntermediateNode parentNode,
          PBIntermediateNode convertedChildNode) =>
      parentNode.addChild(convertedChildNode);
}
