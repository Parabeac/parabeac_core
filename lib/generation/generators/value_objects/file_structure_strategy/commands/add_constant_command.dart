import 'package:get_it/get_it.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_service.dart';
import 'package:path/path.dart' as p;

import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

/// Command used to add a constant to the project's constants file
class AddConstantCommand extends FileStructureCommand {
  String name;
  String type;
  String value;
  final String CONST_DIR_PATH =
      GetIt.I.get<PathService>().constantsRelativePath;
  final String CONST_FILE_NAME = 'constants.dart';

  AddConstantCommand(String UUID, this.name, this.type, this.value)
      : super(UUID);

  /// Adds a constant containing `type`, `name` and `value` to `constants.dart` file
  @override
  Future<void> write(FileStructureStrategy strategy) async {
    strategy.appendDataToFile(
      _addConstant,
      p.join(strategy.GENERATED_PROJECT_PATH, CONST_DIR_PATH),
      CONST_FILE_NAME,
      ownership: FileOwnership.DEV,
    );
  }

  List<String> _addConstant(List<String> lines) {
    var constStr = 'const $type $name = $value;';
    var result = List<String>.from(lines);
    if (!result.contains(constStr)) {
      result.add(constStr);
    }
    return result;
  }
}
