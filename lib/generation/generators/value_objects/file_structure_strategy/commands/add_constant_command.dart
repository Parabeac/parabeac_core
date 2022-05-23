import 'package:get_it/get_it.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_service.dart';
import 'package:path/path.dart' as p;

import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

/// Command used to add a constant to the project's constants file
class AddConstantCommand extends FileStructureCommand {
  /// Optional filename to export the constant to
  String filename;

  /// Optional imports to be appended to the file
  String imports;

  /// Optional [FileOwnership] of the file to be written.
  ///
  /// Will be [FileOwnership.DEV] by default.
  FileOwnership ownershipPolicy;

  List<ConstantHolder> constants;
  final String CONST_DIR_PATH =
      GetIt.I.get<PathService>().constantsRelativePath;
  final String CONST_FILE_NAME = 'constants.dart';

  AddConstantCommand(
    String UUID,
    this.constants, {
    this.filename,
    this.imports = '',
    this.ownershipPolicy,
  }) : super(UUID);

  /// Adds a constant containing `type`, `name` and `value` to `constants.dart` file
  @override
  Future<void> write(FileStructureStrategy strategy) async {
    strategy.appendDataToFile(
      _addConstant,
      p.join(strategy.GENERATED_PROJECT_PATH, CONST_DIR_PATH),
      (filename == null || filename.isEmpty) ? CONST_FILE_NAME : filename,
      ownership: ownershipPolicy ?? FileOwnership.DEV,
    );
  }

  /// Adds the constants of [this] to the list of [lines].
  ///
  /// If any constant of [this] already exists in [lines], it will simply be ignored.
  List<String> _addConstant(List<String> lines) {
    var result = List<String>.from(lines)..add(imports);
    for (var constant in constants) {
      var constStr =
          'const ${constant.type} ${constant.name} = ${constant.value};';
      if (!result.contains(constStr)) {
        result.add(constStr);
      }
    }
    return result;
  }
}

class ConstantHolder {
  // Name of the constant to be added
  String name;
  // Type of the constant to be added
  String type;
  // What the constant's value is
  String value;

  ConstantHolder(
    this.type,
    this.name,
    this.value,
  );
}
