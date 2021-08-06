import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';

/// Class that relies on `code` to implement its `write` method.
abstract class NodeFileStructureCommand extends FileStructureCommand {
  String code;

  /// Depicts the [FileOwnership] of the files that is going to be created
  /// through [write]
  FileOwnership ownership;

  NodeFileStructureCommand(String UUID, this.code,
      this.ownership)
      : super(UUID);
}
