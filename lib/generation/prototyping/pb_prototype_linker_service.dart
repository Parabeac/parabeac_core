import 'package:parabeac_core/generation/prototyping/pb_prototype_aggregation_service.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_prototype_enabled.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/services/intermediate_node_searcher_service.dart';

class PBPrototypeLinkerService {
  PBPrototypeStorage _prototypeStorage;
  PBPrototypeAggregationService _aggregationService;

  PBPrototypeLinkerService() {
    _prototypeStorage = PBPrototypeStorage();
    _aggregationService = PBPrototypeAggregationService();
  }

  Future<PBIntermediateNode> linkPrototypeNodes(
      PBIntermediateTree tree, PBContext context) async {
    var rootNode = tree.rootNode;
    if (rootNode == null) {
      return rootNode;
    }
    for (var element in tree) {
      if (element is InheritedScaffold) {
        if (element is InheritedScaffold) {
          await _prototypeStorage.addPageNode(element, context);
        } else if (element is PrototypeEnable) {
          if (((element)).prototypeNode?.destinationUUID != null &&
              (element).prototypeNode.destinationUUID.isNotEmpty) {
            addAndPopulatePrototypeNode(element, rootNode, context);
          }
        }
      }
    }
    return rootNode;
  }

  void addAndPopulatePrototypeNode(
      var currentNode, var rootNode, PBContext context) async {
    await _prototypeStorage.addPrototypeInstance(currentNode, context);
    var pNode =
        _aggregationService.populatePrototypeNode(context, currentNode);
    if(pNode != null){
      context.tree.replaceNode(currentNode, pNode);
    }
  }
}
