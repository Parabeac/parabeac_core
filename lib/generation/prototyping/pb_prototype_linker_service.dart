import 'package:parabeac_core/generation/prototyping/pb_prototype_aggregation_service.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/services/intermediate_node_searcher_service.dart';

import 'package:parabeac_core/debug/tree_utils.dart';
import 'package:parabeac_core/plugins/injected_app_bar.dart';

class PBPrototypeLinkerService {
  PBPrototypeStorage _prototypeStorage;
  PBPrototypeAggregationService _aggregationService;

  PBPrototypeLinkerService() {
    _prototypeStorage = PBPrototypeStorage();
    _aggregationService = PBPrototypeAggregationService();
  }

  Future<PBIntermediateNode> linkPrototypeNodes(
      PBIntermediateNode rootNode) async {
    if (rootNode == null) {
      return rootNode;
    }

    var stack = <PBIntermediateNode>[];
    PBIntermediateNode rootIntermediateNode;
    stack.add(rootNode);

    while (stack.isNotEmpty) {
      var currentNode = stack.removeLast();
      if (currentNode is PBLayoutIntermediateNode) {
        currentNode.children.forEach(stack.add);
      } else if (currentNode is PBVisualIntermediateNode &&
          currentNode.child != null) {
        stack.add(currentNode.child);
      }
      if (currentNode is InheritedScaffold) {
        if (currentNode.navbar != null) {
          stack.add(currentNode.navbar);
        }
      }
      if (currentNode is InjectedNavbar) {
        if (currentNode.leadingItem != null) {
          stack.add(currentNode.leadingItem);
        }
        if (currentNode.middleItem != null) {
          stack.add(currentNode.middleItem);
        }
        if (currentNode.trailingItem != null) {
          stack.add(currentNode.trailingItem);
        }
      }
      if (currentNode is InheritedScaffold) {
        await _prototypeStorage.addPageNode(currentNode);
      } else if (currentNode is PBInheritedIntermediate &&
          (currentNode as PBInheritedIntermediate)
                  .prototypeNode
                  ?.destinationUUID !=
              null &&
          (currentNode as PBInheritedIntermediate)
              .prototypeNode
              .destinationUUID
              .isNotEmpty) {
        await addAndPopulatePrototypeNode(currentNode, rootNode);
      } else if (currentNode is PBLayoutIntermediateNode &&
          (currentNode as PBLayoutIntermediateNode)
                  .prototypeNode
                  ?.destinationUUID !=
              null &&
          (currentNode as PBLayoutIntermediateNode)
              .prototypeNode
              .destinationUUID
              .isNotEmpty) {
        await addAndPopulatePrototypeNode(currentNode, rootNode);
      }
    }
    return rootNode;
  }

  void addAndPopulatePrototypeNode(var currentNode, var rootNode) async {
    await _prototypeStorage.addPrototypeInstance(currentNode);
    currentNode =
        _aggregationService.populatePrototypeNode(currentNode) ?? currentNode;
    PBIntermediateNodeSearcherService.replaceNodeInTree(
        rootNode, currentNode, currentNode.UUID);
  }
}
