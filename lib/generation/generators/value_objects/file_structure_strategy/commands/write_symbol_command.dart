import 'package:path/path.dart' as p;
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/node_file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

/// Command that writes a `symbol` to the project.
class WriteSymbolCommand extends NodeFileStructureCommand {
  static const String DEFAULT_SYMBOL_PATH = 'lib/widgets';

  final String symbolPath;
  String fileName;

  /// The [relativePath] within the [symbolPath]
  ///
  /// For example, you are looking for `lib/widgets/some_element/element.dart`,
  /// then the [relativePath] would be `some_element/` and the [fileName] would be `element.dart`.
  String relativePath;

  WriteSymbolCommand(String UUID, this.fileName, String code,
      {this.relativePath = '', this.symbolPath = DEFAULT_SYMBOL_PATH})
      : super(UUID, code);

  /// Writes a symbol file containing [data] with [fileName] as its filename.
  ///
  /// Returns path to the file that was created.
  @override
  Future<String> write(FileStructureStrategy strategy) {
    var absPath = relativePath.isEmpty
        ? p.join(strategy.GENERATED_PROJECT_PATH, symbolPath)
        : p.join(strategy.GENERATED_PROJECT_PATH, symbolPath, relativePath);

    strategy.writeDataToFile(code, absPath, fileName, UUID: UUID);
    return Future.value(p.join(absPath, fileName));
  }
}
