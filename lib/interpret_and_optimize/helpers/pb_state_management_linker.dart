import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_state.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_variation.dart';

class PBStateManagementLinker {
  PBStateManagementLinker._internal();

  static final PBStateManagementLinker _instance =
      PBStateManagementLinker._internal();

  factory PBStateManagementLinker() => _instance;

  final Map<String, PBIntermediateNode> _statemap = {};

  bool containsElement(String name) => _statemap.containsKey(name);

  /// Adds the `node` variation to the [DirectedStateGraph] of the
  /// default [PBIntermediateNode], or sets up `node` as default
  /// to receive [IntermediateStates] in its state graph.
  void processVariation(PBIntermediateNode node, String rootNodeName) {
    // Assign `node` as default
    if (!containsElement(rootNodeName)) {
      _statemap[rootNodeName] = node;
    }
    // Add state to default node
    else {
      var intermediateState =
          IntermediateState(variation: IntermediateVariation(node));
      _statemap[rootNodeName]
          .auxiliaryData
          .stateGraph
          .addState(intermediateState);
    }
  }
}
