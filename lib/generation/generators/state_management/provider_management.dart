import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/state_management/state_management_config.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class ProviderManagement extends StateManagementConfig {
  @override
  String setStatefulNode(
      PBIntermediateNode node, PBGenerationManager manager) {}

  String _getNameOfNode(PBIntermediateNode node) {
    var name = node.name;
    var index = name.indexOf('/');
    // Remove everything after the /. So if the name is SignUpButton/Default, we end up with SignUpButton as the name we produce.
    name.replaceRange(index, name.length, '');
    return name;
  }
}
