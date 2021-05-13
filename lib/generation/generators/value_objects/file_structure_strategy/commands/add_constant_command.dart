import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

/// Command used to add a constant to the project's constants file
class AddConstantCommand extends FileStructureCommand {
  String name;
  String type;
  String value;
  final String CONST_PATH = 'lib/constants/constants.dart';

  AddConstantCommand(this.name, this.type, this.value);

  /// Adds a constant containing `type`, `name` and `value` to `constants.dart` file
  @override
  Future<void> write(FileStructureStrategy strategy) {
    var constantStr = 'const $type $name = $value;';
    var path = '${strategy.GENERATED_PROJECT_PATH}${CONST_PATH}';
    appendDataToFile(constantStr, path);
  }
}
