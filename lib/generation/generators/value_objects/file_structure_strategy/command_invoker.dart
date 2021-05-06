import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';

abstract class CommandInvoker {
  void commandCreated(FileStructureCommand command);
}
