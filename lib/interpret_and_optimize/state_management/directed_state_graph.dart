import 'package:directed_graph/directed_graph.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

/// [DirectedStateGraph] is used to represent the states of a
/// `default state management node`.
class DirectedStateGraph extends DirectedGraph<PBIntermediateNode> {

  /// `defaultNode` is considered to be the starting point for this graph.
  ///
  /// Any other [PBIntermediateNode] that is pointed to by `defaultNode` is considered to be
  /// a `variation` of the `defaultNode`.
  PBIntermediateNode defaultNode;

  DirectedStateGraph(
    this.defaultNode, {
    Map<Vertex<PBIntermediateNode>, List<Vertex<PBIntermediateNode>>> edges,
  }) : super(edges);

  /// Adds `variation` as a state of `defaultNode`
  void addVariation(PBIntermediateNode variation) =>
      super.addEdges(defaultNode, [variation]);

  /// Retrieves the states of `defaultNode`
  List<PBIntermediateNode> get states =>
      super.edges(defaultNode).cast<PBIntermediateNode>();
}
