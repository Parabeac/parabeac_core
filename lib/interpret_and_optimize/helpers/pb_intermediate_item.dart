import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
///Currently not entirely sure this class is needed but basically hosts a specific intermediate node.
class PBIntermediateItem {
  PBIntermediateNode node;
  String _type;
  PBIntermediateItem(this.node, String type){
    _type = type;
  }

  set type(String type){
    assert(type != 'SCREEN' || type != 'SHARED' || type != 'MISC', 'Intermediate Item type is not supported yet');
    _type = type;
  }

  String get type => _type;
  
}