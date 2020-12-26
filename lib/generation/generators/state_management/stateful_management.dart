import 'dart:io';

import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/state_management/state_management_config.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:recase/recase.dart';

class StatefulManagement extends StateManagementGenerator {
  @override
  String setStatefulNode(
      PBIntermediateNode node, PBGenerationManager manager, String path) {
    /// Add All States as Stateless Widget classes to a Views folder in the same directory as the current class being written in.
    /// If Views folder doesn't exist, inject the folder then begin writing the Stateless Widgets.
    Directory(path).createSync(recursive: true);
    for (var state in node.auxiliaryData.stateGraph.states) {
      var generator = PBFlutterGenerator(manager.fileStrategy);
      // if (node is! InheritedScaffold) {
      //   manager.fileStrategy.write(
      //     generator.generate(state.variation.node),
      //     '${path}/${state.variation.node.name.snakeCase}.g.dart',
      //   );
      // } else {
      //   print('Parabeac-Core does not support Scaffolds as a state.');
      //   manager.fileStrategy.write(
      //     generator.generate(state.variation.node),
      //     '${path}/${state.variation.node.name.snakeCase}.dart',
      //   );
      // }
    }

    var nameOfDefaultNode = _getNameOfNode(node);
    var defaultNodePath = '${path}/${node.name.snakeCase}';
    var generator = PBFlutterGenerator(manager.fileStrategy);
    // manager.fileStrategy
    //     .write(generator.generate(node), '${defaultNodePath}.g.dart');
    manager.addImport(defaultNodePath);

    var variable = PBVariable(
      '${nameOfDefaultNode}Widget',
      'Widget',
      true,
      '${nameOfDefaultNode.pascalCase}()',
    );

    manager.addGlobalVariable(variable);

    return '${variable.variableName},';
  }

  String _getNameOfNode(PBIntermediateNode node) {
    var name = node.name;
    var index = name.indexOf('/');
    // Remove everything after the /. So if the name is SignUpButton/Default, we end up with SignUpButton as the name we produce.
    name.replaceRange(index, name.length, '');
    return name;
  }

  @override
  String generate(PBIntermediateNode source) {
    // TODO: implement generate
    return source.generator.generate(source);
  }
}
