import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

/// A simple PBIntermediateNode layer & Converted Parent Node holder. (Tuple)
class LayerTuple {
  /// Child Sketch Node
  List<PBIntermediateNode> nodeLayer;

  /// Parent Intermediate node where.
  PBIntermediateNode parent;

  /// Constructor for NodeTuple.
  LayerTuple(this.nodeLayer, this.parent);
}
