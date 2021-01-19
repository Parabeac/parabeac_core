import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';

class PBGenerationViewData {
  final Set<PBVariable> _globalVariables = {};
  final Set<PBVariable> _constructorVariables = {};
  final Set<PBVariable> _methodVariables = {};
  final Set<String> _imports = {};
  bool _isDataLocked = false;

  PBGenerationViewData();

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
    if (!_isDataLocked && variable != null) {
      _globalVariables.add(variable);
    }
  }

  void addAllGlobalVariable(Iterable<PBVariable> variable) =>
      _globalVariables.addAll(variable);

  void addMethodVariable(PBVariable variable) {
    if (!_isDataLocked && variable != null) {
      _methodVariables.add(variable);
    }
  }

  void addAllMethodVariable(Iterable<PBVariable> variables) {
    if (!_isDataLocked && variables != null) {
      _methodVariables.addAll(variables);
    }
  }

  Future<String> removeImportThatContains(String pattern) async {
    for (var import in _imports) {
      if (import is String && import.contains(pattern)) {
        _imports.remove(import);
        return import;
      }
    }
    return '';
  }

  Future<void> replaceImport(String oldImport, String newImport) async {
    var oldVersion = await removeImportThatContains(oldImport);
    if (oldVersion == '') {
      return null;
    }
    var tempList = oldVersion.split('/');
    tempList.removeLast();
    tempList.add(newImport);
    var tempList2 = tempList;
    _imports.add(await _makeImport(tempList2));
  }

  Future<String> _makeImport(List<String> tempList) async {
    var tempString = tempList.removeAt(0);
    for (var item in tempList) {
      tempString += '/${item}';
      if (item == 'view') {
        tempString += '/${tempList.removeLast()}';
        break;
      }
    }
    return tempString;
  }
}
