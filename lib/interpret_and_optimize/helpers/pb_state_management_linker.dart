import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_state.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_variation.dart';

class PBStateManagementLinker {
  PBStateManagementLinker._internal() {
    interpret = Interpret();
    _statemap = {};
    stateQueue = [];
  }

  static final PBStateManagementLinker _instance =
      PBStateManagementLinker._internal();

  factory PBStateManagementLinker() => _instance;

  Interpret interpret;

  Map<String, PBIntermediateNode> _statemap;

  List<Future> stateQueue;

  bool containsElement(String name) => _statemap.containsKey(name);

  /// Adds the `node` variation to the [DirectedStateGraph] of the
  /// default [PBIntermediateNode], or sets up `node` as default
  /// to receive [IntermediateStates] in its state graph.
  void processVariation(PBIntermediateNode node, String rootNodeName) async {
    // Assign `node` as default
    if (!containsElement(rootNodeName)) {
      _statemap[rootNodeName] = node;
    }
    // Add state to default node
    else {
      stateQueue.add(_interpretVariationNode(node).then((processedNode) {
        var intermediateState =
            IntermediateState(variation: IntermediateVariation(processedNode));
        _statemap[rootNodeName]
            .auxiliaryData
            .stateGraph
            .addState(intermediateState);
      }));
    }
  }

  /// Runs the state management [PBIntermediateNode] through
  /// the necessary interpretation services.
  Future<PBIntermediateNode> _interpretVariationNode(
      PBIntermediateNode node) async {
    var visualServiceResult = await interpret.visualGenerationService(
        (node as PBInheritedIntermediate).originalRef,
        node.currentContext,
        Stopwatch()..start(),
        ignoreStates: true);
    var pluginServiceResult = await interpret.pluginService(
        visualServiceResult, node.currentContext, Stopwatch()..start());
    var layoutServiceResult = await interpret.layoutGenerationService(
        pluginServiceResult,
        pluginServiceResult.currentContext,
        Stopwatch()..start());
    return await interpret.alignGenerationService(layoutServiceResult,
        layoutServiceResult.currentContext, Stopwatch()..start());
  }
}
