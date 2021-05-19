import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';

/// Class that relies on `code` to implement its `write` method.
abstract class NodeFileStructureCommand extends FileStructureCommand {
  String code;
  NodeFileStructureCommand(String UUID, this.code) : super(UUID);
}
