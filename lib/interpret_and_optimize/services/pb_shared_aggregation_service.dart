import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/element_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:quick_log/quick_log.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

import 'intermediate_node_searcher_service.dart';

class PBSharedInterAggregationService {
  PBSymbolStorage _symbolStorage;

  var log = Logger('PBSharedInterAggregationService');

  static final PBSharedInterAggregationService _singleInstance =
      PBSharedInterAggregationService._internal();

  ///These are [PBSharedInstanceIntermediateNode] that have not found their [PBSharedMasterNode]; they are
  ///waiting to see their [PBSharedMasterNode] in order to populate their attributes.
  List<PBSharedInstanceIntermediateNode> _unregSymQueue;

  Iterable<PBSharedInstanceIntermediateNode> get unregSymQueue =>
      _unregSymQueue;

  factory PBSharedInterAggregationService() => _singleInstance;

  PBSharedInterAggregationService._internal() {
    _symbolStorage = PBSymbolStorage();
    _unregSymQueue = <PBSharedInstanceIntermediateNode>[];
  }

  ///Within the [PBSymbolStorage], look for the [PBInstanceOverride] of the [PBSharedInstanceIntermediateNode].
  ///Those properties are going to be in a registered [PBSharedMasterNode], otherwise,
  ///it's going to enter in a queue where it waits until that instance is registered.
  void gatherSharedValues(
      PBSharedInstanceIntermediateNode sharedIntermediateNode) {
    var master = _searchMasterNode(sharedIntermediateNode.SYMBOL_ID);
    if (master != null) {
      populateSharedInstanceNode(master, sharedIntermediateNode);
    } else {
      _unregSymQueue.add(sharedIntermediateNode);
    }
  }

  ///Within its [rootChildNode], look for the [PBMasterOverride] of the [PBSharedMasterNode],
  ///if one of the values is a [PBSharedInstanceIntermediateNode] then we
  ///are going to look for its [PBInstanceOverride] if it does not have one.
  void gatherSharedParameters(PBSharedMasterNode sharedMasterNode,
      PBIntermediateNode rootChildNode, PBContext context) {
    for (var prop in sharedMasterNode.overridableProperties) {
      var targetUUID = PBInputFormatter.findLastOf(prop?.UUID, '/');
      prop.value = PBIntermediateNodeSearcherService.searchNodeByUUID(
          rootChildNode, targetUUID, context.tree);
      if (prop.value == null) {
        // add Designer Warning here, not even sure if this is the designers fault or not
        log.warning('UUID: $targetUUID not found in searchNodeByUUID');
      }
      if ((prop.value != null) && (prop.type == 'symbolID')) {
        // prop.value.currentContext = rootChildNode.currentContext;

        ///if the [PBSharedMasterNode] contains [PBSharedInstanceIntermediateNode] as parameters
        ///then its going gather the information of its [PBSharedMasterNode].
        gatherSharedValues(prop.value);
      }
    }

    sharedMasterNode.overridableProperties
        .removeWhere((prop) => prop == null || prop.value == null);
  }

  ///Its going to check the [PBSharedInstanceIntermediateNode]s and the [PBSharedMasterNode]s that are coming through
  ///the [PBSymbolStorage]. To see if we can find the [PBSharedMasterNode] that belongs to the [PBSharedInstanceIntermediateNode]
  ///that do not have their values solved.
  void analyzeSharedNode(dynamic node) {
    if (_unregSymQueue.isEmpty) {
      return;
    }
    var iterator = _unregSymQueue.iterator;
    if (node is PBSharedMasterNode) {
      while (iterator.moveNext()) {
        if (node is PBInheritedIntermediate &&
            iterator.current.SYMBOL_ID == node.SYMBOL_ID) {
          populateSharedInstanceNode(node, iterator.current);
        }
      }
      _unregSymQueue.removeWhere((sym) => sym.SYMBOL_ID == node.SYMBOL_ID);
    }
  }

  ///Getting the information necessary from the [PBSharedMasterNode] to the [PBSharedInstanceIntermediateNode]
  void populateSharedInstanceNode(PBSharedMasterNode masterNode,
      PBSharedInstanceIntermediateNode instanceIntermediateNode) {
    if (masterNode == null || instanceIntermediateNode == null) {
      return;
    }
    if (masterNode?.SYMBOL_ID == instanceIntermediateNode?.SYMBOL_ID) {
      var elementStorage = ElementStorage();
      var masterTree = elementStorage
          .treeUUIDs[elementStorage.elementToTree[masterNode.UUID]];
      var tree = elementStorage.treeUUIDs[
          elementStorage.elementToTree[instanceIntermediateNode.UUID]];
      if (masterTree != tree) {
        tree.addDependent(masterTree);
      }

      ///Get the attributes of the [masterNode] to the [instanceIntermediateNode] here ([instanceIntermediateNode] attributes)
      instanceIntermediateNode.functionCallName = masterNode.name;
      instanceIntermediateNode.foundMaster = true;
    }
  }

  PBSharedMasterNode _searchMasterNode(String masterUUID) =>
      _symbolStorage.getSharedMasterNodeBySymbolID(masterUUID);
}
