import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:recase/recase.dart';

abstract class Middleware {
  static var variableNames = {};

  /// Using chain of reponsibility to handle the incoming nodes in the generation phase, [nextMiddleware]
  /// will be responsible of handling the incoming node or passing it to the next node.
  Middleware nextMiddleware;

  PBGenerationManager generationManager;
  GenerationConfiguration configuration;

  Middleware(this.generationManager, this.configuration, {this.nextMiddleware});

  String getNameOfNode(PBIntermediateNode node) => getName(node.name);

  String getName(String name) {
    var index = name.indexOf('/');
    // Remove everything after the /. So if the name is SignUpButton/Default, we end up with SignUpButton as the name we produce.
    return index < 0
        ? name
        : name.replaceRange(index, name.length, '').pascalCase;
  }

  /// Applying the [Middleware] logic to the [node]; modifying it or even eliminating it by returning `null`.
  Future<PBIntermediateTree> applyMiddleware(PBIntermediateTree tree) =>
      handleTree(tree);

  Future<PBIntermediateTree> handleTree(PBIntermediateTree tree) {
    return nextMiddleware == null
        ? Future.value(tree)
        : nextMiddleware.applyMiddleware(tree);
  }

  void addImportToCache(String id, String path) {
    PBGenCache().setPathToCache(id, path);
  }

  String getVariableName(String name) {
    if (!variableNames.containsKey(name)) {
      variableNames[name] = 1;
      return name;
    } else {
      return name + '_' + (++variableNames[name]).toString();
    }
  }
}

class GeneartionConfiguration {}
