import 'dart:io';

import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

abstract class FileStructureCommand {
  /// Method that executes the [FileStructureCommand]'s action.
  Future<dynamic> write(FileStructureStrategy strategy);

  /// Writes `data` to file at `fileAbsPath`.
  ///
  /// [fileAbsPath] should be the absolute path of the file
  void writeDataToFile(String data, String fileAbsPath) {
    File(fileAbsPath).createSync(recursive: true);
    var writer = File(fileAbsPath);
    writer.writeAsStringSync(data);
  }

  /// Appends [data] to the end of file located at [fileAbsPath].
  ///
  /// Creates the file if the file at [fileAbsPath] does not exist.
  void appendDataToFile(String data, String fileAbsPath) {
    var file = File(fileAbsPath);
    if (file.existsSync()) {
      file.writeAsStringSync(data, mode: FileMode.append);
    } else {
      writeDataToFile(data, fileAbsPath);
    }
  }
}
