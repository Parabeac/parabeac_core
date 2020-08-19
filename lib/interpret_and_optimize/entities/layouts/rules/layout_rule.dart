import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

///Represents specific Rules a [PBLayoutIntermediateNode] follows
abstract class LayoutRule{
  bool testRule(PBIntermediateNode currentNode, PBIntermediateNode nextNode);
}
///Are rules that execute certain actions post layout convertion
abstract class PostConditionRule extends LayoutRule{
  dynamic executeAction(PBIntermediateNode currentNode, PBIntermediateNode nextNode);
}