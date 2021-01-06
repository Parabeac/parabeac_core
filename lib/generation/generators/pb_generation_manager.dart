import 'package:parabeac_core/generation/generators/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/pb_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import 'pb_variable.dart';

/// Resposible for generating the code of a [PBIntermediateNode] Tree.
///
/// Furthermore, it provides a set of method that allows [PBIntermediateNode]s to add
/// imports, dependencies, etc.
abstract class PBGenerationManager {
  FileStructureStrategy fileStrategy;

  ///* Keep track of the imports the current page may have
  final Set<String> _imports = {};
  Iterator<String> get imports => _imports.iterator;

  ///* Keep track of the current page body
  StringBuffer body;

  Type rootType;

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
  String get methodVariableStr {
    var buffer = StringBuffer();
    var it = _methodVariables.iterator;
    while (it.moveNext()) {
      var param = it.current;
      buffer.writeln(
          '${param.type} ${PBInputFormatter.formatLabel(param.variableName)} = ${param.defaultValue};');
    }
    return buffer.toString();
  }

  PBGenerationManager(
    this.fileStrategy,
  );
  void addImport(String value) {
    if (value != null) {
      _imports.add(value);
    }
  }

  String generate(PBIntermediateNode rootNode);

  void addDependencies(String packageName, String version) =>
      PBFlutterWriter().addDependency(packageName, version);

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
