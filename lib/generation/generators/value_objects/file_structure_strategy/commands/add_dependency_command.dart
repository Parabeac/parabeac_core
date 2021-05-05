import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

class AddDependencyCommand extends FileStructureCommand {
  String package;
  String version;

  AddDependencyCommand(this.package, this.version);

  @override
  Future<void> write(FileStructureStrategy strategy) {
    // TODO: append the dependency to pubspec.yaml directly
    throw UnimplementedError();
  }
}
