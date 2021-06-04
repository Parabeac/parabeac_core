import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_prototype_enabled.dart';

/// Interface that defines that the node was derived from the design files.
abstract class PBInheritedIntermediate implements PrototypeEnable {
  final originalRef;

  PBInheritedIntermediate(this.originalRef) {
    if (originalRef is DesignNode) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
  }
}
