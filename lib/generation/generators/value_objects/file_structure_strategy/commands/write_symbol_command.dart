import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

class WriteSymbolCommand implements FileStructureCommand {
  String name;
  String data;

  WriteSymbolCommand(this.name, this.data);

  @override
  Future<String> write(FileStructureStrategy strategy) {
    // TODO: implement write
    throw UnimplementedError();
  }
}
