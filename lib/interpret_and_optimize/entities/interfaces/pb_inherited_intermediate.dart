import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';

/// Interface that defines that the node was derived from the design files.
abstract class PBInheritedIntermediate {
  final DesignNode originalRef;

  PBInheritedIntermediate(this.originalRef);
}
