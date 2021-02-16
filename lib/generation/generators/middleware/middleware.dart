import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:recase/recase.dart';

abstract class Middleware {
  PBGenerationManager generationManager;

  Middleware(this.generationManager);

  String getNameOfNode(PBIntermediateNode node) => getName(node.name);

  String getName(String name) {
    var index = name.indexOf('/');
    // Remove everything after the /. So if the name is SignUpButton/Default, we end up with SignUpButton as the name we produce.
    return index < 0
        ? name
        : name.replaceRange(index, name.length, '').pascalCase;
  }

  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) =>
      Future.value(node);

  void addImportToCache(String id, String path) {
    PBGenCache().addToCache(id, path);
  }
}
