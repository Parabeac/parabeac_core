import 'package:parabeac_core/generation/prototyping/pb_prototype_aggregation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBPrototypeStorage {
  static final PBPrototypeStorage _singleInstance =
      PBPrototypeStorage._internal();

  factory PBPrototypeStorage() => _singleInstance;
  PBPrototypeStorage._internal();

  ///All the prototype Instances
  final Map<String, PBIntermediateNode> _pbPrototypeInstanceNodes = {};

  /// Mapp that will store the `PBIntermediateNode` page found
  final Map<String, PBIntermediateNode> _pbPages = {};

  Iterable<PBIntermediateNode> get pagesNodes => _pbPages.values;

  Iterable<String> get pagesIDs => _pbPages.keys;

  Iterable<PBIntermediateNode> get prototypeIntanceNodes =>
      _pbPrototypeInstanceNodes.values;

  Iterable<String> get prototypeIDs => _pbPrototypeInstanceNodes.keys;

  Future<bool> addPrototypeInstance(PBIntermediateNode prototypeNode) async {
    if (_pbPrototypeInstanceNodes.containsKey(prototypeNode.UUID)) {
      return false;
    }

    await PBPrototypeAggregationService()
        .analyzeIntermediateNode(prototypeNode);
    _pbPrototypeInstanceNodes['${prototypeNode.UUID}'] = prototypeNode;
    return true;
  }

  Future<bool> addPageNode(PBIntermediateNode pageNode) async {
    if (_pbPages.containsKey(pageNode.UUID)) {
      return false;
    }
    await PBPrototypeAggregationService().analyzeIntermediateNode(pageNode);
    _pbPages['${pageNode.UUID}'] = pageNode;
    return true;
  }

  PBIntermediateNode getAllPrototypeByID(String id) {
    var node = getPrototype(id);
    node ??= getPrototypeInstance(id);
    return node;
  }

  PBIntermediateNode getPrototype(String id) {
    var node = getPrototypeNode(id);
    node ??= getPageNode(id);
    return node;
  }

  bool removePageWithID(String id) {
    return (_pbPages.remove(id) != null);
  }

  PBIntermediateNode getPrototypeInstance(String id) {
    return _pbPrototypeInstanceNodes[id];
  }

  PBIntermediateNode getPageNode(String id) => _pbPages['$id'];

  PBIntermediateNode getPageNodeById(String pageID) =>
      _pbPages.values.firstWhere(
        (element) => element.UUID == pageID,
        orElse: () => null,
      );

  PBIntermediateNode getPrototypeNode(String id) =>
      _pbPrototypeInstanceNodes['$id'];

  String getNameOfPageWithID(String id) {
    return (_pbPages.containsKey(id) && _pbPages[id] is PBInheritedIntermediate)
        ? (_pbPages[id] as PBInheritedIntermediate)
            .prototypeNode
            .destinationName
        : null;
  }
}
