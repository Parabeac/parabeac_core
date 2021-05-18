import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/node_file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

/// Command that writes a `symbol` to the project.
class WriteSymbolCommand extends NodeFileStructureCommand {
  String name;
  final String SYMBOL_PATH = 'lib/widgets';
  String relativePath;

  WriteSymbolCommand(this.name, String code, {this.relativePath}) : super(code);

  /// Writes a symbol file containing [data] with [name] as its filename.
  ///
  /// Returns path to the file that was created.
  @override
  Future<String> write(FileStructureStrategy strategy) {
    var absPath;
    if (relativePath.isEmpty) {
      absPath = '${strategy.GENERATED_PROJECT_PATH}$SYMBOL_PATH/$name';
    } else {
      absPath =
          '${strategy.GENERATED_PROJECT_PATH}$SYMBOL_PATH/$relativePath$name';
    }
    writeDataToFile(code, absPath);
    return Future.value(absPath);
  }
}
