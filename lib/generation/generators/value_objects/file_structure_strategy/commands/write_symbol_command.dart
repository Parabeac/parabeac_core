import 'package:get_it/get_it.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_service.dart';
import 'package:path/path.dart' as p;
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/node_file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

/// Command that writes a `symbol` to the project.
class WriteSymbolCommand extends NodeFileStructureCommand {
  static String DEFAULT_SYMBOL_PATH =
      GetIt.I.get<PathService>().widgetsRelativePath;

  String symbolPath;
  String fileName;

  /// The [symbolPath] has the relative path within
  ///
  /// For example, you are looking for `lib/widgets/some_element/element.dart`,
  /// then the [symbolPath] would be `lib/widgets/some_element/`

  WriteSymbolCommand(
    String UUID,
    this.fileName,
    String code, {
    this.symbolPath = '',
    FileOwnership ownership = FileOwnership.PBC,
  }) : super(UUID, code, ownership);

  /// Writes a symbol file containing [generationViewData] with [fileName] as its filename.
  ///
  /// Returns path to the file that was created.
  @override
  Future<String> write(FileStructureStrategy strategy) {
    symbolPath = symbolPath.isEmpty ? DEFAULT_SYMBOL_PATH : symbolPath;
    var absPath = p.join(strategy.GENERATED_PROJECT_PATH, symbolPath);

    strategy.writeDataToFile(code, absPath, fileName,
        UUID: UUID, ownership: ownership);
    return Future.value(p.join(absPath, fileName));
  }
}
