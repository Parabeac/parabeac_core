import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';

class PBIntermediateNodeSearcherService {
  ///Searching for a [PBIntermediateNode] by their unique identifier. If no [PBIntermediateNode] is found
  ///with that [uuid], then `null` should be returned to the caller.
  PBIntermediateNode searchNodeByUUID(
      PBIntermediateNode rootNode, String uuid) {
    if (rootNode == null) {
      return rootNode;
    }

    var stack = <PBIntermediateNode>[];
    stack.add(rootNode);

    while (stack.isNotEmpty) {
      var currentNode = stack.removeLast();
      if (currentNode is PBLayoutIntermediateNode) {
        currentNode.children.forEach((child) => stack.add(child));
      } else if (currentNode is PBVisualIntermediateNode &&
          currentNode.child != null) {
        stack.add(currentNode.child);
      }

      if (currentNode is PBInheritedIntermediate && currentNode.UUID == uuid) {
        return currentNode;
      }
    }
    return null;
  }
}
