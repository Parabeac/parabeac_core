import 'package:parabeac_core/design_logic/artboard.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_aggregation_service.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';

class PBPrototypeLinkerService {
  PBPrototypeStorage _prototypeStorage;
  PBPrototypeAggregationService _aggregationService;

  PBPrototypeLinkerService() {
    _prototypeStorage = PBPrototypeStorage();
    _aggregationService = PBPrototypeAggregationService();
  }

  Future<PBIntermediateNode> linkSymbols(PBIntermediateNode rootNode) async {
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

      if (currentNode is PBArtboard) {
        await _prototypeStorage.addPageNode(currentNode);
        _aggregationService.gatherIntermediateNodes(
            currentNode.prototypeNode, currentNode);
      } else if (currentNode.prototypeNode != null &&
          currentNode.prototypeNode.destinationUUID != null &&
          currentNode.prototypeNode.destinationUUID.isNotEmpty) {
        await _prototypeStorage.addPrototypeInstance(currentNode);
        _aggregationService.gatherPrototypeNodes(currentNode.prototypeNode);
      }

      rootIntermediateNode ?? currentNode;
    }
    return rootIntermediateNode;
  }
}
