import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_item.dart';

class PBIntermediateGroup {
  final String name;
  List <PBIntermediateGroup> subgroups = [];
  List <PBIntermediateItem> items = [];

  PBIntermediateGroup(this.name);
  
  void addItem(PBIntermediateItem item){
    items.add(item);
  }

  void addSubgroup(PBIntermediateGroup subgroup){
    subgroups.add(subgroup);
  }
}