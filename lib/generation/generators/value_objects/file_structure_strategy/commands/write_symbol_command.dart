import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/node_file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

class WriteSymbolCommand implements NodeFileStructureCommand {
  @override
  String code;
  String name;
  final String SYMBOL_PATH = 'lib/widgets';

  WriteSymbolCommand(this.name, this.code);

  /// Writes a symbol file containing [data] with [name] as its filename.
  ///
  /// Returns path to the file that was created.
  @override
  Future<String> write(FileStructureStrategy strategy) {
    var absPath = '${strategy.GENERATED_PROJECT_PATH}$SYMBOL_PATH/$name';
    strategy.pageWriter.write(code, absPath);
    return Future.value(absPath);
  }
}
