import 'package:parabeac_core/generation/prototyping/pb_dest_holder.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

/// This class keeps track of the [PrototypeNode]s that do not have necessary
/// properties from their destination [PBIntermediateNode] and populates them
/// once the destination [PBIntermediateNode] is found.
class PBPrototypeAggregationService {
  /// Storage of registered [PrototypeNode]
  PBPrototypeStorage _storage;

  /// List representing [PrototypeNodes] that have not found their
  /// destination [PBIntermediateNodes]
  List<PBInheritedIntermediate> _unregNodes;

  PBPrototypeAggregationService._internal() {
    _storage = PBPrototypeStorage();
    _unregNodes = [];
  }

  static final PBPrototypeAggregationService _instance =
      PBPrototypeAggregationService._internal();

  factory PBPrototypeAggregationService() => _instance;

  /// Iterates through `_unregNodes` to find whether any [PBPrototypeNode]'s
  /// `destinationUUID` matches the `node` UUID. If there is a match, populate
  /// the [PrototypeNode].
  void analyzeIntermediateNode(PBIntermediateNode node) {
    if (_unregNodes.isEmpty) {
      return;
    }
    var pNode;
    for (var _pNode in _unregNodes) {
      if (_pNode.prototypeNode.destinationUUID == node.UUID) {
        _pNode.prototypeNode.destinationName = node.name;
      }
    }
    _unregNodes.removeWhere(
        (pNode) => pNode.prototypeNode.destinationUUID == node.UUID);
  }

  /// Provide the `pNode` with the necessary attributes it needs from the `iNode`
  PBIntermediateNode populatePrototypeNode(PBIntermediateNode iNode) {
    if (iNode == null || iNode is! PBInheritedIntermediate) {
      return iNode;
    }

    var destHolder = PBDestHolder(iNode.topLeftCorner, iNode.bottomRightCorner,
        iNode.UUID, (iNode as PBInheritedIntermediate).prototypeNode);
    destHolder.addChild(iNode);
    return destHolder;
  }
}
