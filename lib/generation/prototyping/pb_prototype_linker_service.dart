import 'package:parabeac_core/eggs/injected_app_bar.dart';
import 'package:parabeac_core/eggs/injected_tab.dart';
import 'package:parabeac_core/eggs/injected_tab_bar.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_injected_node.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_aggregation_service.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/services/intermediate_node_searcher_service.dart';

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
      currentNode.attributes.forEach((attribute) {
        attribute.attributeNodes.forEach(stack.add);
      });
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
          currentNode.prototypeNode?.destinationUUID != null &&
          currentNode.prototypeNode.destinationUUID.isNotEmpty) {
        await addAndPopulatePrototypeNode(currentNode, rootNode);
      } else if (currentNode is InjectedContainer &&
          currentNode.prototypeNode?.destinationUUID != null &&
          currentNode.prototypeNode.destinationUUID.isNotEmpty) {
        await addAndPopulatePrototypeNode(currentNode, rootNode);
      } else if (currentNode is Tab &&
          currentNode.prototypeNode?.destinationUUID != null &&
          currentNode.prototypeNode.destinationUUID.isNotEmpty) {
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
