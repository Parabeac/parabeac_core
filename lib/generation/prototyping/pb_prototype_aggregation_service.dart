import 'package:parabeac_core/eggs/injected_tab.dart';
import 'package:parabeac_core/generation/prototyping/pb_dest_holder.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_prototype_enabled.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/element_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:path/path.dart';

/// This class keeps track of the [PrototypeNode]s that do not have necessary
/// properties from their destination [PBIntermediateNode] and populates them
/// once the destination [PBIntermediateNode] is found.
class PBPrototypeAggregationService {
  /// Storage of registered [PrototypeNode]
  PBPrototypeStorage _storage;

  /// List representing [PrototypeNodes] that have not found their
  /// destination [PBIntermediateNodes]
  List<PrototypeEnable> _unregNodes;

  PBPrototypeAggregationService._internal() {
    _storage = PBPrototypeStorage();
    _unregNodes = [];
  }

  static final PBPrototypeAggregationService _instance =
      PBPrototypeAggregationService._internal();

  factory PBPrototypeAggregationService() => _instance;

  List screens = [];

  /// Iterates through `_unregNodes` to find whether any [PBPrototypeNode]'s
  /// `destinationUUID` matches the `node` UUID. If there is a match, populate
  /// the [PrototypeNode].
  Future<void> analyzeIntermediateNode(
      PBIntermediateNode node, PBContext context) async {
    if (node is InheritedScaffold) {
      screens.add(node);

      ///check if any of the [IntermediateNode]s looking for a destination contains their destination.
      iterateUnregisterNodes(node);
    } else if (node is PrototypeEnable) {
      var page = _storage.getPageNodeById(
          (node as PrototypeEnable).prototypeNode.destinationUUID);
      if (page == null) {
        _unregNodes.add(node as PrototypeEnable);
      } else {
        _addDependent(node, page);
      }
    }
    _unregNodes.removeWhere(
        (pNode) => pNode.prototypeNode.destinationUUID == node.UUID);
  }

  void _addDependent(PBIntermediateNode target, PBIntermediateNode dependent) {
    var elementStorage = ElementStorage();
    var targetTree =
        elementStorage.treeUUIDs[elementStorage.elementToTree[target.UUID]];
    var dependentTree =
        elementStorage.treeUUIDs[elementStorage.elementToTree[dependent.UUID]];
    if (dependentTree != targetTree) {
      dependentTree.addDependent(targetTree);
    }
  }

  /// Provide the `pNode` with the necessary attributes it needs from the `iNode`
  PBIntermediateNode populatePrototypeNode(
      PBContext context, PBIntermediateNode iNode) {
    // TODO: refactor the structure
    if (iNode == null) {
      return iNode;
    } else if (iNode is PBInheritedIntermediate) {
      var destHolder = PBDestHolder(
        iNode.UUID,
        iNode.frame,
        (iNode as PBInheritedIntermediate).prototypeNode,
      );
      //FIXME destHolder.addChild(iNode);
      return destHolder;
    } else if (iNode is PBLayoutIntermediateNode) {
      var destHolder = PBDestHolder(
        iNode.UUID,
        iNode.frame,
        iNode.prototypeNode,
      );
      //FIXME destHolder.addChild(iNode);
      return destHolder;
    } else if (iNode is InjectedContainer) {
      var destHolder = PBDestHolder(
        iNode.UUID,
        iNode.frame,
        iNode.prototypeNode,
      );
      //FIXME destHolder.addChild(iNode);
      return destHolder;
    } else if (iNode is Tab) {
      var destHolder = PBDestHolder(
        iNode.UUID,
        iNode.frame,
        iNode.prototypeNode,
      );
      context.tree.childrenOf(iNode).forEach((element) {
        //FIXME destHolder.addChild(element);
      });
      return destHolder;
    } else {
      return iNode;
    }
  }

  void iterateUnregisterNodes(PBIntermediateNode node) {
    for (var _pNode in _unregNodes) {
      if (_pNode.prototypeNode.destinationUUID == node.UUID) {
        _pNode.prototypeNode.destinationName = node.name;
        _addDependent(_pNode as PBIntermediateNode, node);
      }
    }
  }
}
