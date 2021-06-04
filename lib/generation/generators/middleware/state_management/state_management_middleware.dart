import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';

/// This [Middleware] is going to focus on the [PBIntermediateNode]s that
/// satisfy either [containsMasterState] or simply [containsState].
///
/// Unlike the regular [Middleware] were they are able to handle the entire
/// [PBIntermediateTree], the [StateManagementMiddleware] is going to handle each
/// individual [PBIntermediateNode].
abstract class StateManagementMiddleware extends Middleware {
  StateManagementMiddleware(PBGenerationManager generationManager,
      GenerationConfiguration configuration)
      : super(generationManager, configuration);

  /// Forwards all of the nodes of the tree to the [handleStatefulNode],
  /// the method overridden by the [StateManagementMiddleware].
  ///
  /// Since the [StateManagementMiddleware] is meant to process all the
  /// stateful [PBIntermediateNode] within a [tree], it has to traverse all the [tree] [PBIntermediateNode]s.
  /// To accomplish this, the [StateManagementMiddleware] will forward all
  /// the [tree] nodes to the [handleStatefulNode] method. Once all the nodes have
  /// been processed, we will assign the [PBIntermediateTree.rootNode] back to the [tree] and return the [tree].
  /// The last thing to note here is if the [PBIntermediateTree.rootNode] happens to be null,
  /// in which case the tree will return `null`; no other [Middleware] will be applied to the [tree],
  /// making the final result `null`.
  @override
  Future<PBIntermediateTree> applyMiddleware(PBIntermediateTree tree) {
    return Future.wait(tree.map((node) {
      if (containsState(node) || containsMasterState(node)) {
        return handleStatefulNode(node);
      }
      return Future.value(node);
    })).then((nodes) {
      tree.rootNode = nodes.first;
      return handleTree(tree.rootNode == null ? null : tree);
    });
  }

  /// Handles the nodes that are stateful(either [containsState] or [containsMasterState]).
  Future<PBIntermediateNode> handleStatefulNode(PBIntermediateNode node);

  /// Checks whether the master of the [PBSharedInstanceIntermediateNode] (if the [node]
  /// is a symbol) [containsState].
  bool containsMasterState(PBIntermediateNode node) {
    if (node is PBSharedInstanceIntermediateNode) {
      return node.isMasterState ||
          containsState(
              PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID));
    }
    return false;
  }

  /// Checks wheather the [node] contains any states.
  bool containsState(PBIntermediateNode node) =>
      node?.auxiliaryData?.stateGraph?.states?.isNotEmpty ?? false;
}
