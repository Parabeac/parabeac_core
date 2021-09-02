import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/element_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_alignment_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_layout_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_plugin_control_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_symbol_linker_service.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/directed_state_graph.dart';

class PBStateManagementLinker {
  ElementStorage elementStorage;
  Interpret interpret;
  PBStateManagementLinker._internal() {
    interpret = Interpret();
    stateQueue = [];
    elementStorage = ElementStorage();
  }

  static final PBStateManagementLinker _instance =
      PBStateManagementLinker._internal();

  factory PBStateManagementLinker() => _instance;

  // Interpret interpret;

  final Map<String, DirectedStateGraph> _rootNameToGraph = {};

  List<Future> stateQueue;

  bool containsElement(String name) => _rootNameToGraph.containsKey(name);

  /// Returns true if `name` exists in the statemap and it is
  /// a symbol instance.
  bool isSymbolInstance(String name) =>
      _rootNameToGraph.containsKey(name) &&
      _rootNameToGraph[name] is PBSharedInstanceIntermediateNode;

  void processVariation(PBIntermediateNode node, String rootNodeName,
      PBIntermediateTree tree) async {
    // if `node` is default, create a new graph
    if (!containsElement(rootNodeName)) {
      _rootNameToGraph[rootNodeName] = DirectedStateGraph(node);
    }

    // Add variation to default state node
    else {
      if (node is PBSharedMasterNode) {
        var tempSym =
            PBSymbolStorage().getSharedInstanceNodeBySymbolID(node.SYMBOL_ID);
        tempSym?.forEach((element) => element.isMasterState = true);
      }
      stateQueue.add(_interpretVariationNode(node, tree).then((processedNode) =>
          _rootNameToGraph[rootNodeName].addVariation(processedNode)));
    }
  }

  /// Gets the [DirectedStateGraph] of `rootNodeName` or `null` if it does not exist.
  DirectedStateGraph getDirectedStateGraphOfName(String rootNodeName) =>
      _rootNameToGraph[rootNodeName];

  /// Runs the state management [PBIntermediateNode] through
  /// the necessary interpretation services.
  Future<PBIntermediateNode> _interpretVariationNode(
      PBIntermediateNode node, PBIntermediateTree tree) async {
    var builder = AITServiceBuilder([PBSymbolLinkerService()]);

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
