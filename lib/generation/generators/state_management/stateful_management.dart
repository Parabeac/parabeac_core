import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/state_management/state_management_config.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';

class StatefulManagement extends StateManagementConfig {
  @override
  String setStatefulNode(PBIntermediateNode node, PBGenerationManager manager) {
    /// Add All States as Stateless Widget classes to a Views folder in the same directory as the current class being written in.
    /// If Views folder doesn't exist, inject the folder then begin writing the Stateless Widgets.
    for (var i = 0; i < node.auxiliaryData.stateGraph.states.length; i++) {
      /// Doesn't have to be implemented this way but you may get the idea. T
      /// he function adds the node & generation of the node to the relative directory 'Views'.
      /// If Views didn't exist create the folder.
      // manager.pageWriter.addNodeToDirectory(directory: "Views", node.auxiliaryData.stateGraph.states[i].node);
    }
    var nameOfDefaultNode = _getNameOfNode(node);

    /// Same as the for loop expect this will take care of the default node
    // manager.pageWriter.addNodeToDirectory(directory: "Views", node);
    /// Lastly, we will need the import for the default node to inject into the parent class.
    // manager.addImport('${directory} + ${nameOfDefaultNode}.dart');

    var variable = PBVariable(
      '${nameOfDefaultNode}',
      'Widget',
      true,
      /* Should be able to set default value to the default state. */
    );

    manager.addInstanceVariable(variable);

    return '${variable.variableName},';
  }

  String _getNameOfNode(PBIntermediateNode node) {
    var name = node.name;
    var index = name.indexOf('/');
    // Remove everything after the /. So if the name is SignUpButton/Default, we end up with SignUpButton as the name we produce.
    name.replaceRange(index, name.length, '');
    return name;
  }
}
