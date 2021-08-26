import 'dart:io';

import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_alignment_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_layout_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_plugin_control_service.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_state.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_variation.dart';
import 'package:path/path.dart';

class PBStateManagementLinker {
  Interpret interpret;
  PBStateManagementLinker._internal() {
    interpret = Interpret();
    _statemap = {};
    stateQueue = [];
  }

  static final PBStateManagementLinker _instance =
      PBStateManagementLinker._internal();

  factory PBStateManagementLinker() => _instance;

  // Interpret interpret;

  Map<String, PBIntermediateNode> _statemap;

  List<Future> stateQueue;

  bool containsElement(String name) => _statemap.containsKey(name);

  /// Returns true if `name` exists in the statemap and it is
  /// a symbol instance.
  bool isSymbolInstance(String name) =>
      _statemap.containsKey(name) &&
      _statemap[name] is PBSharedInstanceIntermediateNode;

  /// Adds the `node` variation to the [DirectedStateGraph] of the
  /// default [PBIntermediateNode], or sets up `node` as default
  /// to receive [IntermediateStates] in its state graph.
  void processVariation(PBIntermediateNode node, String rootNodeName,
      PBIntermediateTree tree) async {
    // Assign `node` as default
    if (!containsElement(rootNodeName)) {
      _statemap[rootNodeName] = node;
    }
    // Replacing a default node that was an instance node
    else if (node is PBSharedMasterNode &&
        _statemap[rootNodeName] is PBSharedInstanceIntermediateNode) {
      var instanceNode = _statemap[rootNodeName];

      // Transfer states to new default node
      instanceNode.auxiliaryData.stateGraph.states
          .forEach((state) => node.auxiliaryData.stateGraph.addState(state));

      // Add old default node as state of new default node
      stateQueue.add(
          _interpretVariationNode(instanceNode, tree).then((processedNode) {
        var intermediateState = IntermediateState(
          variation: IntermediateVariation(processedNode),
          context: tree.context,
        );
        node.auxiliaryData.stateGraph.addState(intermediateState);
      }));

      // Set new default node
      _statemap[rootNodeName] = node;
    }
    // Add state to default node
    else {
      if (node is PBSharedMasterNode) {
        var tempSym =
            PBSymbolStorage().getSharedInstanceNodeBySymbolID(node.SYMBOL_ID);
        tempSym?.forEach((element) => element.isMasterState = true);
      }
      stateQueue.add(_interpretVariationNode(node, tree).then((processedNode) {
        var intermediateState = IntermediateState(
          variation: IntermediateVariation(processedNode),
          context: tree.context,
        );
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
      PBIntermediateNode node, PBIntermediateTree tree) async {
    var builder = AITServiceBuilder();

    builder.addTransformation((PBContext context, PBIntermediateTree tree) {
      return PBPluginControlService()
          .convertAndModifyPluginNodeTree(tree, context);
    }).addTransformation((PBContext context, PBIntermediateTree tree) {
      return PBLayoutGenerationService().extractLayouts(tree, context);
    }).addTransformation((PBContext context, PBIntermediateTree tree) {
      return PBAlignGenerationService().addAlignmentToLayouts(tree, context);
    });
    await builder.build(tree: tree, context: tree.context);
    return tree.rootNode;
  }
}
