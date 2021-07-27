import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_shared_aggregation_service.dart';

class PBSymbolLinkerService {
  PBSymbolStorage _symbolStorage;
  PBSharedInterAggregationService _aggregationService;

  PBSymbolLinkerService() {
    _symbolStorage = PBSymbolStorage();
    _aggregationService = PBSharedInterAggregationService();
  }

// /Linking [PBSharedMasterNode] and [PBSharedInstanceIntermediateNode] together; linking its
// /parameter and values.
  Future<PBIntermediateNode> linkSymbols(PBIntermediateNode rootNode) async {
    if (rootNode == null) {
      return rootNode;
    }

    var stack = <PBIntermediateNode>[];
    PBIntermediateNode rootIntermediateNode;
    stack.add(rootNode);

    while (stack.isNotEmpty) {
      var currentNode = stack.removeLast();
      // Traverse `currentNode's` attributes and add to stack
      currentNode.attributes.forEach((attribute) {
        attribute.attributeNodes.forEach((node) {
          node.currentContext ??= currentNode.currentContext;
          stack.add(node);
        });
      });

      if (currentNode is PBSharedMasterNode) {
        await _symbolStorage.addSharedMasterNode(currentNode);
        _aggregationService.gatherSharedParameters(
            currentNode, currentNode.child);
      } else if (currentNode is PBSharedInstanceIntermediateNode) {
        await _symbolStorage.addSharedInstance(currentNode);
        _aggregationService.gatherSharedValues(currentNode);
      }

      rootIntermediateNode ??= currentNode;
    }
    return rootIntermediateNode;
  }
}
