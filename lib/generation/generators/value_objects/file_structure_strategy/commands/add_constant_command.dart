import 'package:get_it/get_it.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_service.dart';
import 'package:path/path.dart' as p;

import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:recase/recase.dart';

/// Command used to write constants to the project's constants file
class WriteConstantsCommand extends FileStructureCommand {
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

  WriteConstantsCommand(
    String UUID,
    this.constants, {
    this.filename,
    this.imports = '',
    this.ownershipPolicy,
  }) : super(UUID);

  /// Writes constants containing `type`, `name` and `value` to `constants.dart` file
  @override
  Future<void> write(FileStructureStrategy strategy) async {
    var constBuffer = StringBuffer()..writeln(imports);

    var className = filename.pascalCase;

    /// Write class declaration
    constBuffer.writeln('class $className {');

    /// Write constants
    constants.forEach((constant) {
      var description =
          constant.description.isNotEmpty ? '/// ${constant.description}' : '';
      var constStr =
          'static const ${constant.type} ${constant.name} = ${constant.value};';

      constBuffer.writeln('$description\n$constStr');
    });

    constBuffer.writeln('}');

    /// Write file
    strategy.writeDataToFile(
      constBuffer.toString(),
      p.join(strategy.GENERATED_PROJECT_PATH, CONST_DIR_PATH),
      filename ?? CONST_FILE_NAME,
      ownership: ownershipPolicy ?? FileOwnership.PBC,
    );
  }
}

class ConstantHolder {
  /// Name of the constant to be added
  String name;

  /// Type of the constant to be added
  String type;

  /// What the constant's value is
  String value;

  /// Optional description to put as comment above the constant
  String description;

  ConstantHolder(
    this.type,
    this.name,
    this.value, {
    this.description = '',
  });
}
