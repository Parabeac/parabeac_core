import 'dart:io';

import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/state_management/state_management_config.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:recase/recase.dart';

class StatefulManagement extends StateManagementConfig {
  @override
  String setStatefulNode(
      PBIntermediateNode node, PBGenerationManager manager, String path) {
    /// Add All States as Stateless Widget classes to a Views folder in the same directory as the current class being written in.
    /// If Views folder doesn't exist, inject the folder then begin writing the Stateless Widgets.
    var pathToViews = '${path}/views';
    Directory(pathToViews).createSync(recursive: true);
    for (var state in node.auxiliaryData.stateGraph.states) {
      var generator = PBFlutterGenerator(manager.pageWriter);
      manager.pageWriter.write(
        generator.generate(state.variation.node),
        '${pathToViews}/${state.variation.node.name.snakeCase}.dart',
      );
    }

    var nameOfDefaultNode = _getNameOfNode(node);
    var defaultNodePath = '${pathToViews}/${node.name.snakeCase}';
    var generator = PBFlutterGenerator(manager.pageWriter);
    manager.pageWriter.write(generator.generate(node), defaultNodePath);
    manager.addImport(defaultNodePath);

    var variable = PBVariable(
      '${nameOfDefaultNode}Widget',
      'Widget',
      true,
      '${nameOfDefaultNode.pascalCase}()',
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
