import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';

/// The [DryRunFileStructureStrategy] is going to mimick a real [FileStructureStrategy], however, its not going to modify the FileSystem.
///
/// The main use of this class is to analyze the final location of all the [PBIntermediateTree]s given a set of
/// [FileStructureCommand]s that are going to execute. The only use of this class right now if by the [ImportHelper],
/// where we are going to record the final import of all the [PBIntermediateTree]s before actually creating the files.
/// Keep in mind that most of the methods in the [DryRunFileStructureStrategy] are going to do nothing other than
/// notify the [FileWriterObserver]s that new files are being created.
class DryRunFileStructureStrategy extends FileStructureStrategy {
  List<FileStructureCommand> dryRunCommands;
  DryRunFileStructureStrategy(String GENERATED_PROJECT_PATH,
      PBPageWriter pageWriter, PBProject pbProject)
      : super(GENERATED_PROJECT_PATH, pageWriter, pbProject) {
    dryRunCommands = [];
  }

  @override
  Future<void> setUpDirectories();

  @override
  Future<void> generatePage(String code, String fileName, {args});

  @override
  void writeDataToFile(String data, String directory, String name,
      {String UUID}) {
    var file = getFile(directory, name);
    _notifyObsevers(file.path, UUID);
  }

  @override
  void appendDataToFile(modFile, String directory, String name,
      {String UUID, bool createFileIfNotFound = true}) {
    var file = getFile(directory, name);
    if (!file.existsSync() && createFileIfNotFound) {
      _notifyObsevers(file.path, UUID);
    }
  }

  @override
  void commandCreated(FileStructureCommand command) {
    dryRunCommands.add(command);
    super.commandCreated(command);
  }

  void _notifyObsevers(String path, String UUID) =>
      fileObservers.forEach((observer) => observer.fileCreated(path, UUID));
}
