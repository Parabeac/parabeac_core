import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';

class PBIntermediateNodeSearcherService {
  ///Searching for a [PBIntermediateNode] by their unique identifier. If no [PBIntermediateNode] is found
  ///with that [uuid], then `null` should be returned to the caller.
  static PBIntermediateNode searchNodeByUUID(
      PBIntermediateNode rootNode, String uuid, PBIntermediateTree tree) {
    if (rootNode == null) {
      return rootNode;
    }

    var stack = <PBIntermediateNode>[];
    stack.add(rootNode);

    while (stack.isNotEmpty) {
      var currentNode = stack.removeLast();
      stack.addAll(tree.childrenOf(currentNode));

      if (currentNode is PBInheritedIntermediate && currentNode.UUID == uuid) {
        return currentNode;
      } else if (currentNode is PBSharedInstanceIntermediateNode) {
        // Traverse intermediate node to find UUID
        var master = PBSymbolStorage()
            .getSharedMasterNodeBySymbolID(currentNode.SYMBOL_ID);
        if (master != null) {
          stack.add(master);
        }
      }
    }
    return null;
  }

  ///Replacing the [PBIntermediateNode] that contains the [uuid] in the tree that starts at [rootNode] with the
  ///[candidate] node. The function will return `false` if it could not successfully replace the node inside the tree,
  ///make sure the node exists! Else the function is going to return `true` if was successful.
  // static bool replaceNodeInTree(
  //     PBIntermediateNode rootNode, PBIntermediateNode candidate, String uuid) {
  //   if (rootNode == null) {
  //     return false;
  //   }

  //   var stack = <PBIntermediateNode>[];
  //   stack.add(rootNode);

  //   while (stack.isNotEmpty) {
  //     var currentNode = stack.removeLast();
  //     if (currentNode is InheritedScaffold) {
  //       var tabbar = currentNode.getAttributeNamed('bottomNavigationBar');
  //       var tabs = tabbar?.getAllAtrributeNamed('tabs');
  //       if (tabbar != null && tabs.isNotEmpty ?? false) {
  //         for (var i = 0; i < tabs.length; i++) {
  //           var child = tabs[i];
  //           if (child.UUID == uuid) {
  //             // tabs[i].child = candidate;
  //             return true;
  //           }
  //           // stack.add(child);
  //         }
  //       }
  //     }
  //     if (currentNode is PBLayoutIntermediateNode) {
  //       for (var i = 0; i < currentNode.children.length; i++) {
  //         var child = currentNode.children[i];
  //         if (child.UUID == uuid) {
  //           currentNode.replaceChildAt(i, candidate);
  //           return true;
  //         }
  //         stack.add(child);
  //       }
  //     } else if (currentNode is PBVisualIntermediateNode &&
  //         currentNode.child != null) {
  //       if (currentNode.child.UUID == uuid) {
  //         currentNode.child = candidate;
  //         return true;
  //       }
  //       stack.add(currentNode.child);
  //     }
  //   }
  //   return false;
  // }
}
