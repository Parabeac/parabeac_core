import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

/// A simple child Sketch Node & Converted Parent Node holder. (Tuple)
class NodeTuple {
  /// Child Sketch Node
  DesignNode sketchNode;

  /// Parent Intermediate node where `sketchNode.interpretNode()` should be assigned as a child.
  PBIntermediateNode convertedParent;

  /// Constructor for NodeTuple.
  NodeTuple(this.sketchNode, this.convertedParent);
}
