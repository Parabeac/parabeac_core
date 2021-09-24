import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:path/path.dart' as p;
/// [FileStructureCommand] uses the command pattern to create units of works that create/modify the
/// FileSystem. 
/// 
/// The [FileStructureCommand]s are send to the [FileStructureCommand] that is responsible for
/// executing the command and actually writing them into the file system.
abstract class FileStructureCommand {
  final String UUID;

  FileStructureCommand(this.UUID);

  /// Method that executes the [FileStructureCommand]'s action.
  Future<dynamic> write(FileStructureStrategy strategy);
}
