import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';

mixin StatefulNodeMixin {
  bool containsMasterState(PBIntermediateNode node) {
    if (node is PBSharedInstanceIntermediateNode) {
      return node.isMasterState ||
          containsState(
              PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID));
    }
    return false;
  }

  bool containsState(PBIntermediateNode node) =>
      node?.auxiliaryData?.stateGraph?.states?.isNotEmpty ?? false;
}
