import 'package:parabeac_core/generation/generators/pb_generation_manager_data.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/pb_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

/// Resposible for generating the code of a [PBIntermediateNode] Tree.
///
/// Furthermore, it provides a set of method that allows [PBIntermediateNode]s to add
/// imports, dependencies, etc.
abstract class PBGenerationManager {
  FileStructureStrategy fileStrategy;

  ///* Keep track of the current page body
  StringBuffer body;

  Type rootType;

  PBGenerationManagerData data;

  PBGenerationManager(this.fileStrategy, {this.data});

  String generate(PBIntermediateNode rootNode);

  void addDependencies(String packageName, String version) =>
      PBFlutterWriter().addDependency(packageName, version);

  String getPath(String uuid) => PBGenCache().getPath(uuid);

  String generateImports();

  String generateGlobalVariables();

  String generateConstructor(String name);
}
