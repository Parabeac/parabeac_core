import 'dart:io';

import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

abstract class FileStructureCommand {
  /// Method that executes the [FileStructureCommand]'s action.
  Future<dynamic> write(FileStructureStrategy strategy);
}
