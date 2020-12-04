import 'dart:io';

import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/state_management/state_management_config.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:recase/recase.dart';

class ProviderManagement extends StateManagementConfig {
  @override
  String setStatefulNode(
      PBIntermediateNode node, PBGenerationManager manager, String path) {
    /// Folder Paths needed for Provider
    var pathToViews = '${path}/views';
    var pathToModel = '${path}/model';
    Directory(pathToViews).createSync(recursive: true);

    /// Create all Views
    for (var state in node.auxiliaryData.stateGraph.states) {
      var generator = PBFlutterGenerator(manager.pageWriter);
      manager.pageWriter.write(
        generator.generate(state.variation.node),
        '${pathToViews}/${state.variation.node.name.snakeCase}.dart',
      );
    }

    /// Create Default View
    var nameOfDefaultNode = _getNameOfNode(node);
    var defaultNodePath = '${pathToViews}/${node.name.snakeCase}';
    var generator = PBFlutterGenerator(manager.pageWriter);
    manager.pageWriter.write(generator.generate(node), defaultNodePath);
    manager.addImport(defaultNodePath);

    /// Create Model File

    var nameOfModel = '${_getNameOfNode(node)}Model';

    /// Add model reference to top of build method before returning the widget in the build method.
    // manager.addToTopOfBuildMethod('''
    //   final ${nameOfModel}Ref = context.watch<${nameOfModel}>()
    // ''');

    return '''

      Provider(create: (_) => ${nameOfModel}(),
      child: ${nameOfModel}Ref.???
      ),

    ''';
  }

  String _getNameOfNode(PBIntermediateNode node) {
    var name = node.name;
    var index = name.indexOf('/');
    // Remove everything after the /. So if the name is SignUpButton/Default, we end up with SignUpButton as the name we produce.
    name.replaceRange(index, name.length, '');
    return name;
  }

  String providerModelGenerator() {
    return ''' 
      import ...
    ''';
  }
}
