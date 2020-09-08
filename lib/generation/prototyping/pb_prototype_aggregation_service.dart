import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/services/intermediate_node_searcher_service.dart';

/// This class keeps track of the [PrototypeNode]s that do not have necessary
/// properties from their destination [PBIntermediateNode] and populates them
/// once the destination [PBIntermediateNode] is found.
class PBPrototypeAggregationService {
  /// Storage of registered [PrototypeNode]
  PBPrototypeStorage _storage;

  /// List representing [PrototypeNodes] that have not found their
  /// destination [PBIntermediateNodes]
  List<PrototypeNode> _unregNodes;

  PBPrototypeAggregationService._internal() {
    _storage = PBPrototypeStorage();
    _unregNodes = [];
  }

  static final PBPrototypeAggregationService _instance =
      PBPrototypeAggregationService._internal();

  factory PBPrototypeAggregationService() => _instance;

  /// Search the `rootNode` for the [PBIntermediateNode] contained in
  /// `pNode` destinationUUID
  void gatherIntermediateNodes(
      PrototypeNode pNode, PBIntermediateNode rootNode) {
    var destNode = PBIntermediateNodeSearcherService.searchNodeByUUID(
        rootNode, pNode.destinationUUID);

    if (destNode?.prototypeNode != null) {
      gatherPrototypeNodes(pNode);
    }
  }

  /// Checks if there is a [PBIntermediateNode] in the storage
  /// which corresponds to the `pNode` destination UUID.
  /// If there is such a [PBIntermediateNode], give the necessary attributes to `pNode`.
  /// Otherwise, add `pNode` to the queue.
  void gatherPrototypeNodes(PrototypeNode pNode) {
    var iNode = _storage.getPageNodeById(pNode.destinationUUID);
    if (iNode != null) {
      populatePrototypeNode(pNode, iNode);
    } else {
      _unregNodes.add(pNode);
    }
  }

  /// Iterates through `_unregNodes` to find whether any [PBPrototypeNode]'s
  /// `destinationUUID` matches the `node` UUID. If there is a match, populate
  /// the [PrototypeNode].
  void analyzeIntermediateNode(PBIntermediateNode node) {
    if (_unregNodes.isEmpty) {
      return;
    }
    for (var iNode in _unregNodes) {
      if (iNode.destinationUUID == node.UUID) {
        populatePrototypeNode(iNode, node);
      }
    }
    _unregNodes.removeWhere((pNode) => pNode.destinationUUID == node.UUID);
  }

  /// Provide the `pNode` with the necessary attributes it needs from the `iNode`
  void populatePrototypeNode(PrototypeNode pNode, PBIntermediateNode iNode) {
    if (pNode == null || iNode == null) {
      return;
    }
    pNode.destinationName = iNode.name;
  }
}
