import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

class WriteScreenCommand implements FileStructureCommand {
  String name;
  String path;
  String value;

  WriteScreenCommand(this.name, this.path, this.value);

  @override
  Future<String> write(FileStructureStrategy strategy) {
    // TODO: implement write
    throw UnimplementedError();
  }
}
