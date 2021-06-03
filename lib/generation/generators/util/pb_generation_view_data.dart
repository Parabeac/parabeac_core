import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';

class PBGenerationViewData {
  final Map<String, PBVariable> _globalVariables = {};
  final Map<String, PBVariable> _constructorVariables = {};
  final Map<String, PBVariable> _methodVariables = {};
  final Set<String> _imports = {};
  final Set<String> _toDispose = {};
  bool _isDataLocked = false;
  bool hasParams = false;


  PLATFORM platform;
  ORIENTATION orientation;

  PBGenerationViewData();

  Iterator<String> get toDispose => _toDispose.iterator;

  Iterator<PBVariable> get globalVariables => _globalVariables.values.iterator;

  Iterator<PBVariable> get constructorVariables =>
      _constructorVariables.values.iterator;

  ///The [PBVariable]s that need to be added in between the method definition and its return statement
  Iterator<PBVariable> get methodVariables => _methodVariables.values.iterator;

  ///Imports for the current page
  Iterator<String> get imports => _imports.iterator;

  String get methodVariableStr {
    var buffer = StringBuffer();
    var it = _methodVariables.values.iterator;
    while (it.moveNext()) {
      var param = it.current;
      buffer.writeln(
          '${param.type} ${PBInputFormatter.formatLabel(param.variableName)} = ${param.defaultValue};');
    }
    return buffer.toString();
  }

  void lockData() => _isDataLocked = true;

  void addToDispose(String dispose) {
    if (!_isDataLocked &&
        dispose != null &&
        dispose.isNotEmpty &&
        !_toDispose.contains(dispose)) {
      _toDispose.add(dispose);
    }
  }

  void addImport(String import) {
    if (!_isDataLocked && import != null && import.isNotEmpty) {
      _imports.add(import);
    }
  }

  void addConstructorVariable(PBVariable parameter) {
    if (!_isDataLocked &&
        parameter != null &&
        !_constructorVariables.containsKey(parameter.variableName)) {
      _constructorVariables[parameter.variableName] = parameter;
    }
  }

  void addGlobalVariable(PBVariable variable) {
    if (!_isDataLocked &&
        variable != null &&
        !_globalVariables.containsKey(variable.variableName)) {
      _globalVariables[variable.variableName] = variable;
    }
  }

  void addMethodVariable(PBVariable variable) {
    if (!_isDataLocked &&
        variable != null &&
        !_methodVariables.containsKey(variable.variableName)) {
      _methodVariables[variable.variableName] = variable;
    }
  }
}
