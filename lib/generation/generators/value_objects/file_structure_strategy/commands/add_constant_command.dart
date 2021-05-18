import 'dart:ffi';
import 'package:path/path.dart' as p;

import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

/// Command used to add a constant to the project's constants file
class AddConstantCommand extends FileStructureCommand {
  String name;
  String type;
  String value;
  final String CONST_DIR_PATH = 'lib/constants/';
  final String CONST_FILE_NAME = 'constants.dart';

  AddConstantCommand(this.name, this.type, this.value);

  /// Adds a constant containing `type`, `name` and `value` to `constants.dart` file
  @override
  Future<void> write(FileStructureStrategy strategy) {
    strategy.appendDataToFile(
      _addConstant,
      p.join(strategy.GENERATED_PROJECT_PATH, CONST_DIR_PATH),
      CONST_FILE_NAME,
    );
  }

  List<String> _addConstant(List<String> lines) {
    var constStr = 'const $type $name = $value;';
    if (!lines.contains(constStr)) {
      lines.add(constStr);
    }
    return lines;
  }
}
