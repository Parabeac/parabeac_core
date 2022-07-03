import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/row.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

///tree.where((element) => element != null).toList().reversed.map((e) => e.name).toList()
class PBConstraintGenerationService extends AITHandler {
  PBConstraintGenerationService();

  /// Traverse to the bottom of the tree, and implement constraints to nodes that don't already contain it such as [InjectedContainer] and then work our way up the tree.
  /// Through Traversal, discover whether there are elements that will conflict on scaling, if so, change the layout to a Stack.
  Future<PBIntermediateTree> implementConstraints(
      PBIntermediateTree tree, PBContext context) {
    if (tree.rootNode == null) {
      return Future.value(tree);
    }

    for (var node
        in tree.where((element) => element != null).toList().reversed) {
      var children = tree.childrenOf(node);
      var child = children.isEmpty ? null : children.first;
      if (node.constraints == null) {
        if (child.constraints == null) {
          node.constraints = PBIntermediateConstraints(
              pinBottom: false, pinLeft: false, pinRight: false, pinTop: false);
        } else {
          node.constraints = child.constraints;
        }
      }
    }
    return Future.value(tree);
  }

  @override
  Future<PBIntermediateTree> handleTree(
      PBContext context, PBIntermediateTree tree) {
    return implementConstraints(tree, context);
  }
}
