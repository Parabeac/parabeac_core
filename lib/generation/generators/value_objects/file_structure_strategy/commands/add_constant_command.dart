import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

class AddConstantCommand implements FileStructureCommand {
  String name;
  String type;
  String value;

  AddConstantCommand(this.name, this.type, this.value);

  @override
  Future<void> write(FileStructureStrategy strategy) {
    var constantStr = 'const $type $name = $value';
    var path = '${strategy.GENERATED_PROJECT_PATH}/${strategy.RELATIVE_CONSTANT_PATH}/constants.dart';
    //TODO: validate adding a method to pageWriter to `append` to a file rather than completely overwriting it.
    strategy.pageWriter.write(constantStr, path);
  }
}
