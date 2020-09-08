import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBPrototypeStorage {
  static final PBPrototypeStorage _singleInstance =
      PBPrototypeStorage._internal();

  factory PBPrototypeStorage() => _singleInstance;
  PBPrototypeStorage._internal();

  ///All the prototype Instances
  final Map<String, PrototypeNode> _pbPrototypeInstanceNodes = {};

  /// Mapp that will store the `PBIntermediateNode` page found
  final Map<String, PBIntermediateNode> _pbPages = {};

  Iterable<PBIntermediateNode> get pagesNodes => _pbPages.values;

  Iterable<String> get pagesIDs => _pbPages.keys;

  Iterable<PrototypeNode> get prototypeIntanceNodes =>
      _pbPrototypeInstanceNodes.values;

  Iterable<String> get prototypeIDs => _pbPrototypeInstanceNodes.keys;

  Future<bool> addPrototypeInstance(PrototypeNode prototypeNode) async {
    if (_pbPrototypeInstanceNodes.containsKey(prototypeNode.destinationUUID)) {
      return false;
    }
    // await TODO:
    _pbPrototypeInstanceNodes['${prototypeNode.destinationUUID}'] =
        prototypeNode;
    return true;
  }

  Future<bool> addPageNode(PBIntermediateNode pageNode) async {
    if (_pbPages.containsKey(pageNode.UUID)) {
      return false;
    }
    // await TODO:
    _pbPages['${pageNode.UUID}'] = pageNode;
    return true;
  }

  PrototypeNode getAllPrototypeByID(String id) {
    var node = getPrototype(id);
    node ??= getPrototypeInstance(id);
    return node;
  }

  PrototypeNode getPrototype(String id) {
    var node = getPrototypeNode(id);
    node ??= getPageNode(id).prototypeNode;
    return node;
  }

  bool removePageWithID(String id) {
    return (_pbPages.remove(id) != null);
  }

  PrototypeNode getPrototypeInstance(String id) {
    return _pbPrototypeInstanceNodes[id];
  }

  PBIntermediateNode getPageNode(String id) => _pbPages['$id'];

  PBIntermediateNode getPageNodeBySymbolID(String pageID) =>
      _pbPages.values.firstWhere(
        (element) => element.UUID == pageID,
        orElse: () => null,
      );

  PrototypeNode getPrototypeNode(String id) => _pbPrototypeInstanceNodes['$id'];

  String getNameOfPageWithID(String id) {
    return _pbPages.containsKey(id)
        ? _pbPages[id].prototypeNode.destinationName
        : null;
  }
}
