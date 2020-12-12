import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_state_management_linker.dart';

/// Class that interprets state management nodes
class PBStateManagementHelper {
  static final PBStateManagementHelper _instance =
      PBStateManagementHelper._internal();

  factory PBStateManagementHelper() => _instance;

  PBStateManagementLinker linker;

  PBStateManagementHelper._internal() {
    linker = PBStateManagementLinker();
  }

  void interpretStateManagementNode(PBIntermediateNode node) {
    if (_hasValidName(node.name)) {
      var nameAndStates = node.name.split('/');
      var stateName = nameAndStates[0];
      // TODO: these states will be used for phase 2 of state management
      var variations = nameAndStates[1].split(',');
      PBStateManagementLinker().processVariation(node, stateName);
    }
  }

  /// Returns `true` if `node` is or would be the default node,
  /// `false` otherwise
  bool isDefaultNode(PBIntermediateNode node) =>
      !linker.containsElement(node.name);

  /// Returns true if `name` is a valid state management name
  bool _hasValidName(String name) =>
      RegExp(r'^\w*\/(\w*,?\s?)*[\w]$').hasMatch(name);
}
