import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_shared_aggregation_service.dart';

class PBSymbolLinkerService extends AITHandler {
  PBSymbolStorage _symbolStorage;
  PBSharedInterAggregationService _aggregationService;

  PBSymbolLinkerService() {
    _symbolStorage = PBSymbolStorage();
    _aggregationService = PBSharedInterAggregationService();
  }

// /Linking [PBSharedMasterNode] and [PBSharedInstanceIntermediateNode] together; linking its
// /parameter and values.
  Future<PBIntermediateTree> linkSymbols(
      PBIntermediateTree tree, PBContext context) async {
    var rootNode = tree.rootNode;
    if (rootNode == null) {
      return Future.value(tree);
    }

    for (var vertex in tree) {
      var node = vertex;
      if (node is PBSharedMasterNode) {
        await _symbolStorage.addSharedMasterNode(node);
        _aggregationService.gatherSharedParameters(
            node, context.tree.childrenOf(node).first, context);
      } else if (node is PBSharedInstanceIntermediateNode) {
        await _symbolStorage.addSharedInstance(node);
        _aggregationService.gatherSharedValues(node);
      }
    }

    return Future.value(tree);
  }

  @override
  Future<PBIntermediateTree> handleTree(
      PBContext context, PBIntermediateTree tree) {
    return linkSymbols(tree, context);
  }
}
