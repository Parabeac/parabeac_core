import 'dart:async';

import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_shared_aggregation_service.dart';

/// Singleton class that stores sketch node symbols for easy access
class PBSymbolStorage {
  static final PBSymbolStorage _singleInstance = PBSymbolStorage._internal();

  factory PBSymbolStorage() => _singleInstance;
  PBSymbolStorage._internal();

  ///All the symbols Instances
  final Map<String, PBSharedInstanceIntermediateNode> _pbSharedInstanceNodes =
      {};

  /// Map that will store the `PBIntermediateNode` symbol masters found in the [Symbols] page
  final Map<String, PBSharedMasterNode> _pbSharedMasterNodes = {};

  Iterable<PBSharedMasterNode> get sharedMasterNodes =>
      _pbSharedMasterNodes.values;

  /// The `IDs` of stored `Symbols`
  Iterable<String> get sharedMastersIDs => _pbSharedMasterNodes.keys;

  Iterable<PBSharedInstanceIntermediateNode> get sharedInstanceNodes =>
      _pbSharedInstanceNodes.values;

  Iterable<String> get sharedInstanceIDs => _pbSharedInstanceNodes.keys;

  ///Add [PBSharedInstanceIntermediateNode] to the in storage; return [true]
  ///if added else [false] if it exists.
  Future<bool> addSharedInstance(
      PBSharedInstanceIntermediateNode symbolInstance) async {
    if (_pbSharedInstanceNodes.containsKey(symbolInstance.UUID)) {
      return false;
    }
    PBSharedInterAggregationService().analyzeSharedNode(symbolInstance);
    _pbSharedInstanceNodes['${symbolInstance.UUID}'] = symbolInstance;
    return true;
  }

  ///Add [PBSharedMasterNode] into the storage, return `true` if added else
  ///`false` if it exists.
  Future<bool> addSharedMasterNode(PBSharedMasterNode masterNode) async {
    if (_pbSharedMasterNodes.containsKey(masterNode.UUID)) {
      return false;
    }
    PBSharedInterAggregationService().analyzeSharedNode(masterNode);
    _pbSharedMasterNodes['${masterNode.UUID}'] = masterNode;
    return true;
  }

  ///Getting the symbol instance that contains the specific
  PBIntermediateNode getSymbolInstance(String id) {
    return _pbSharedInstanceNodes[id];
  }

  void gatherPBSharedInstanceAtt() {}

  ///Looks for all the symbols; this includes the [pageSymbols],
  ///[_pbSharedMasterNodes], and [_pbSharedInstanceNodes].
  PBIntermediateNode getAllSymbolById(String id) {
    var node = getSymbol(id);
    node ??= getSymbolInstance(id);
    return node;
  }

  ///Looks for the symbol in both the [_pbSharedMasterNodes] and
  ///the [pageSymbols] maps
  PBIntermediateNode getSymbol(String id) {
    PBIntermediateNode node = getSharedInstaceNode(id);
    node ??= getSharedMasterNode(id);
    return node;
  }

  /// Removes the symbol with given [id].
  ///
  /// Returns [true] if the object was successfuly removed,
  /// [false] if the object did not exist.
  bool removeSymbolWithId(String id) {
    return (_pbSharedMasterNodes.remove(id) != null);
  }

  /// Returns the symbol with the given [id],
  /// or [null] if no such symbol exists.
  PBSharedMasterNode getSharedMasterNode(String id) =>
      _pbSharedMasterNodes['$id'];

  PBSharedMasterNode getSharedMasterNodeBySymbolID(String symbolID) =>
      _pbSharedMasterNodes.values.firstWhere(
          (element) => element.SYMBOL_ID == symbolID,
          orElse: () => null);

  List<PBSharedInstanceIntermediateNode> getSharedInstanceNodeBySymbolID(
          String symbolID) =>
      _pbSharedInstanceNodes.values
          .where((element) => element.SYMBOL_ID == symbolID)
          .toList();

  PBSharedInstanceIntermediateNode getSharedInstaceNode(String id) =>
      _pbSharedInstanceNodes['$id'];

  String getNameOfSymbolWithID(String id) {
    return _pbSharedMasterNodes.containsKey(id)
        ? _pbSharedMasterNodes[id].name
        : null;
  }
}
