import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';

class PBGenerationViewData {
  final Set<PBVariable> _globalVariables = {};
  final Set<PBVariable> _constructorVariables = {};
  final Set<PBVariable> _methodVariables = {};
  final Set<String> _imports = {};
  final Set<String> _toDispose = {};
  bool _isDataLocked = false;

  PBGenerationViewData();

  Iterator<String> get toDispose => _toDispose.iterator;

  Iterator<PBVariable> get globalVariables => _globalVariables.iterator;

  Iterator<PBVariable> get constructorVariables =>
      _constructorVariables.iterator;

  ///The [PBVariable]s that need to be added in between the method definition and its return statement
  Iterator<PBVariable> get methodVariables => _methodVariables.iterator;

  ///Imports for the current page
  Iterator<String> get imports => _imports.iterator;

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
    if (!_isDataLocked && parameter != null) {
      _constructorVariables.add(parameter);
    }
  }

  void addGlobalVariable(PBVariable variable) {
    if (!_isDataLocked && variable != null && globalHas(variable)) {
      _globalVariables.add(variable);
    }
  }

  bool globalHas(PBVariable variable) {
    for (var v in _globalVariables) {
      if (v.variableName == variable.variableName) {
        return false;
      }
    }
    return true;
  }

  void addAllGlobalVariable(Iterable<PBVariable> variable) =>
      _globalVariables.addAll(variable);

  void addMethodVariable(PBVariable variable) {
    if (!_isDataLocked && variable != null && !_contains(variable)) {
      _methodVariables.add(variable);
    }
  }

  bool _contains(PBVariable variable) {
    var result = false;
    _methodVariables.forEach((element) {
      if (element.variableName == variable.variableName) {
        result = true;
        return result;
      }
    });
    return result;
  }

  void addAllMethodVariable(Iterable<PBVariable> variables) {
    if (!_isDataLocked && variables != null) {
      _methodVariables.addAll(variables);
    }
  }
}
