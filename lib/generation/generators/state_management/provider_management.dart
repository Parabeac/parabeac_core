import 'dart:io';

import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/state_management/state_management_config.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:recase/recase.dart';

class ProviderGeneratorWrapper extends StateManagementGenerator {
  final PACKAGE_NAME = 'provider';
  final PACKAGE_VERSION = '1.0.0';

  @override
  String setStatefulNode(
      PBIntermediateNode node, PBGenerationManager manager, String path) {
    /// Folder Paths needed for Provider
    final PATH_TO_VIEWS = '${path}/views';
    final PATH_TO_MODELS = '${path}/model';
    Directory(PATH_TO_VIEWS).createSync(recursive: true);

    /// Create all Views
    for (var state in node.auxiliaryData.stateGraph.states) {
      var generator = PBFlutterGenerator(manager.pageWriter);
      manager.pageWriter.write(
        generator.generate(state.variation.node),
        '${PATH_TO_VIEWS}/${state.variation.node.name.snakeCase}.dart',
      );
    }

    /// Create Default View
    var nameOfDefaultNode = _getNameOfNode(node);
    var defaultNodePath = '${PATH_TO_VIEWS}/${node.name.snakeCase}';
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

  @override
  String generate(PBIntermediateNode source) {
    var watcherName = _getNameOfNode(source);
    var watcher = PBVariable(watcherName, 'final ', true, 'watch(context)');
    manager.addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
    manager.addImport('import provider;');
    manager.addMethodVariable(watcher);
    return watcherName;
  }
}
