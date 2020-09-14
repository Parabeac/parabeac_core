import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

///Represents some exceptions to the rules.
abstract class LayoutException {
  bool testException(
      PBIntermediateNode currentNode, PBIntermediateNode nextNode);
}
