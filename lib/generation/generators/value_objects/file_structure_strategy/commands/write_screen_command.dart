import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

class WriteScreenCommand implements FileStructureCommand {
  String name;
  String relativePath;
  String data;

  final SCREEN_PATH = 'lib/modules';

  WriteScreenCommand(this.name, this.relativePath, this.data);

  /// Writes a screen file containing [data] to [path] with [name] as its filename.
  ///
  /// Returns path to the file that was created.
  @override
  Future<String> write(FileStructureStrategy strategy) {
    var absPath =
        '${strategy.GENERATED_PROJECT_PATH}/$SCREEN_PATH/$relativePath/$name';
    strategy.pageWriter.write(data, absPath);
    return Future.value(absPath);
  }
}
