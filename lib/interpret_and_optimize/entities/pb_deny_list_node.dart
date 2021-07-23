import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

/// A node that should not be converted to intermediate.
class PBDenyListNode extends PBIntermediateNode {
  PBDenyListNode(
    Point topLeftCorner,
    Point bottomRightCorner,
    String name, {
    String UUID,
    PBContext currentContext,
  }) : super(
          topLeftCorner,
          bottomRightCorner,
          UUID,
          name,
          currentContext: currentContext,
        );

  @override
  void addChild(PBIntermediateNode node) {
    // Unclear whether we should even go into the children if we run into a Deny List node.
    return;
  }

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) => null;
}
