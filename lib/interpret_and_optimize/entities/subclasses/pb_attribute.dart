import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

/// Class that represents an attribute of an IntermediateNode
/// that can have an IntermediateNode inside. `child` or `children`
/// are examples.
class PBAttribute {
  List<PBIntermediateNode> attributeNodes;

  /// To be used for attributes with a single element, sets the first
  /// element of `attributeNodes` to `element`
  set attributeNode(PBIntermediateNode element) => attributeNodes.isEmpty
      ? attributeNodes.add(element)
      : attributeNodes.first = element;

  /// To be used for attributes with a single element, gets the first
  /// element of `attributeNodes`.
  PBIntermediateNode get attributeNode =>
      attributeNodes.isEmpty ? null : attributeNodes.first;

  /// Name of the attribute.
  /// e.g. `child` or `children`
  String attributeName;

  PBAttribute(
    this.attributeName, {
    this.attributeNodes,
  }) {
    attributeNodes ??= [];
  }
}
