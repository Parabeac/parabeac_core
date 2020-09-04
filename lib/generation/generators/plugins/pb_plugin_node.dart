import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

abstract class PBEgg extends PBVisualIntermediateNode {
  /// The allow list semantic name to detect this node.
  String semanticName;

  final String UUID;

  PBEgg(Point topLeftCorner, Point bottomRightCorner, PBContext currentContext,
      {this.UUID})
      : super(topLeftCorner, bottomRightCorner, currentContext, UUID: UUID);

  /// Override this function if you want to make tree modification prior to the layout service.
  /// Be sure to return something or you will remove the node from the tree.
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) =>
      layer;

  PBEgg generatePluginNode(
      Point topLeftCorner, Point bottomRightCorner, DesignNode originalRef);

  void extractInformation(DesignNode incomingNode);

  void addChild(PBIntermediateNode node);
}
