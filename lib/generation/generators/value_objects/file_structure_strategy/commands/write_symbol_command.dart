import 'package:path/path.dart' as p;
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/node_file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

/// Command that writes a `symbol` to the project.
class WriteSymbolCommand extends NodeFileStructureCommand {
  String name;
  final String SYMBOL_PATH = 'lib/widgets';

  WriteSymbolCommand(String UUID, this.name, String code) : super(UUID, code);

  /// Writes a symbol file containing [data] with [name] as its filename.
  ///
  /// Returns path to the file that was created.
  @override
  Future<String> write(FileStructureStrategy strategy) {
    var absPath = p.join(strategy.GENERATED_PROJECT_PATH, SYMBOL_PATH);
    strategy.writeDataToFile(code, absPath, name);
    return Future.value(p.join(absPath, name));
  }
}
