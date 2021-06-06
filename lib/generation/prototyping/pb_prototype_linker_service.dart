import 'package:parabeac_core/generation/prototyping/pb_prototype_aggregation_service.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_prototype_enabled.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
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
    stack.add(rootNode);

    while (stack.isNotEmpty) {
      var currentNode = stack.removeLast();
      if (currentNode == null) {
        continue;
      }
      currentNode.attributes.forEach((attribute) {
        attribute.attributeNodes.forEach(stack.add);
      });
      if (currentNode is InheritedScaffold) {
        await _prototypeStorage.addPageNode(currentNode);
      } else if (currentNode is PrototypeEnable) {
        if ((currentNode as PrototypeEnable).prototypeNode?.destinationUUID !=
                null &&
            (currentNode as PrototypeEnable)
                .prototypeNode
                .destinationUUID
                .isNotEmpty) {
          addAndPopulatePrototypeNode(currentNode, rootNode);
        }
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
