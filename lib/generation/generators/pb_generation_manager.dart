import 'package:parabeac_core/generation/generators/pb_page_writer.dart';
import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import 'pb_variable.dart';

/// Resposible for generating the code of a [PBIntermediateNode] Tree.
///
/// Furthermore, it provides a set of method that allows [PBIntermediateNode]s to add
/// imports, dependencies, etc.
abstract class PBGenerationManager {
  ///[PBPageWriter] writes the generated code into its corresponding files
  PBPageWriter pageWriter;

  ///* Keep track of the imports the current page may have
  final Set<String> _imports = {};
  Iterator<String> get imports => _imports.iterator;

  ///* Keep track of the current page body
  StringBuffer body;

  ///* Keep track of the instance variable a class may have
  final Set<PBVariable> _constructorVariables = {};
  Iterator<PBVariable> get constructorVariables =>
      _constructorVariables.iterator;

  final Set<PBVariable> _globalVariables = {};
  Iterator<PBVariable> get globalVariables => _globalVariables.iterator;

  final Map<String, String> _dependencies = {};
  Iterable<MapEntry<String, String>> get dependencies => _dependencies.entries;

  ///The [PBVariable]s that need to be added in between the method definition and its return statement
  final Set<PBVariable> _methodVariables = {};
  Iterator<PBVariable> get methodVariables => _methodVariables.iterator;

  PBGenerationManager(
    this.pageWriter,
  );
  void addImport(String value) {
    if (value != null) {
      _imports.add(value);
    }
  }

  String generate(PBIntermediateNode rootNode);

  void addDependencies(String packageName, String version) =>
      _dependencies[packageName] = version;

  String getPath(String uuid) => PBGenCache().getPath(uuid);

  void addConstructorVariable(PBVariable param) =>
      _constructorVariables.add(param);

  ///Adding a global variable to the current class that is being generated.
  void addGlobalVariable(PBVariable variable) => _globalVariables.add(variable);

  ///Injects a variable between the method declaration and the return statement of the method being proccessed
  void addMethodVariable(PBVariable variable) => _methodVariables.add(variable);

  String generateImports();

  String generateGlobalVariables();

  String generateConstructor(String name);
}
