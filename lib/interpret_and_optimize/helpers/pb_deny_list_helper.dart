import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_deny_list_node.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

// Helping understand indirect and direct semantics that should remove a node from a tree.
class PBDenyListHelper {
  Map<String, bool> denyList = {
    //iOS Library
    '64A58F18-749F-477C-9B71-E65B82DDC277': true,
    '649B1B1E-2911-49F1-85C2-89387DB7B43F': true,
    '5FD734F9-A5BC-479E-8DDD-5537BCFE2AE4': true,
    '130A23DE-9787-44C2-B81F-D99CF2B323A2': true,
    '937FDFA9-BCF9-4577-AE5E-0CF7FDD47254': true,
  };

  bool isInDenyListDirect(DesignNode node) {
    if (denyList[node.UUID] != null) {
      return true;
    }
    return false;
  }

  PBDenyListNode returnDenyListNodeIfExist(DesignNode node) {
    if (isInDenyListDirect(node)) {
      return PBDenyListNode(Point(0, 0), Point(0, 0), null);
    } else {
      return null;
    }
  }
}
