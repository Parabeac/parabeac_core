import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
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
    if (isValidStateNode(node.name)) {
      var nodeName = _getNodeName(node.name);
      // TODO: these states will be used for phase 2 of state management
      var states = _getStates(node.name);
      linker.processVariation(node, nodeName);
    }
  }

  /// Returns `true` if `node` is or would be the default node,
  /// `false` otherwise
  bool isDefaultNode(PBIntermediateNode node) =>
      node is PBSharedMasterNode &&
      (linker.isSymbolInstance(_getNodeName(node.name)) ||
          !linker.containsElement(_getNodeName(node.name)));

  String _getNodeName(String fullName) =>
      isValidStateNode(fullName) ? fullName.split('/')[0] : '';

  List<String> _getStates(String fullName) =>
      isValidStateNode(fullName) ? fullName.split('/')[1].split(',') : [];

  /// Returns true if `name` is a valid state management name
  bool isValidStateNode(String name) =>
      RegExp(r'^\w*\/(\w*,?\s?)*[\w]$').hasMatch(name);
}
