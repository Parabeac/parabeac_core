import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class ProviderMiddleware extends Middleware {
  final PACKAGE_NAME = 'provider';
  final PACKAGE_VERSION = '1.0.0';

  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) {
    var watcherName = getNameOfNode(node);
    var manager = node.generator.manager;

    var fileStrategy = manager.fileStrategy;
    var watcher = PBVariable(watcherName, 'final ', true, 'watch(context)');
    manager.addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
    manager.addImport('import provider');
    manager.addMethodVariable(watcher);
    fileStrategy.generatePage(node.generator.generate(node, null),
        '${fileStrategy.GENERATED_PROJECT_PATH}${fileStrategy.RELATIVE_VIEW_PATH}EDDIE.g.dart');
    return Future.value(node);
  }
}
