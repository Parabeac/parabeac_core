import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_state_management_helper.dart';

class StateManagementNodeInterpreter extends AITHandler {
  /// Checks whether `node` is a state management node, and interprets it accordingly.
  ///
  /// Returns `null` if `node` is a non-default state management node, effectively removing `node` from the tree.
  /// Returns `node` if it is a default state management node or a non-state management node.
  @override
  Future<PBIntermediateTree> handleTree(
      PBContext context, PBIntermediateTree tree) {
    if (tree.rootNode is! PBSharedMasterNode) {
      return Future.value(tree);
    }
    var node = tree.rootNode;
    var smHelper = PBStateManagementHelper();
    if (smHelper.isValidStateNode(node.name)) {
      if (smHelper.isDefaultNode(node)) {
        smHelper.interpretStateManagementNode(node, tree);
        return Future.value(tree);
      } else {
        /// Remove tree entirely
        smHelper.interpretStateManagementNode(node, tree);
        return Future.value(null);
      }
    }
    return Future.value(tree);
  }
}
