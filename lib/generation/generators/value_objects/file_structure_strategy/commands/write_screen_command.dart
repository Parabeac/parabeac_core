import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:path/path.dart' as p;
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/node_file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

/// Command that writes a `screen` to the project.
class WriteScreenCommand extends NodeFileStructureCommand {
  String name;
  String relativePath;

  static final SCREEN_PATH = 'lib/screens';

  WriteScreenCommand(String UUID, this.name, this.relativePath, String code,
      {FileOwnership ownership = FileOwnership.PBC})
      : super(UUID, code, ownership);

  /// Writes a screen file containing [code] to [path] with [name] as its filename.
  ///
  /// Returns path to the file that was created.
  @override
  Future<String> write(FileStructureStrategy strategy) {
    var absPath =
        p.join(strategy.GENERATED_PROJECT_PATH, SCREEN_PATH, relativePath);
    strategy.writeDataToFile(code, absPath, name,
        UUID: UUID, ownership: ownership);
    return Future.value(p.join(absPath, name));
  }
}
