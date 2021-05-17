import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

/// Command used to add a dependency to `pubspec.yaml`
class AddDependencyCommand extends FileStructureCommand {
  final _PUBSPEC_YAML_NAME = 'pubspec.yaml';

  ///assets yaml decleration
  final String _ASSET_DECLERATION = '\t\t- assets/images/';

  /// Name of the [package]
  String package;

  /// The version of [package]
  String version;

  AddDependencyCommand(this.package, this.version);

  /// Appends `package` and `version` to `pubspec.yaml` dependencies.
  @override
  Future<void> write(FileStructureStrategy strategy) async {
    strategy.appendDataToFile(
      _addPackage,
      strategy.GENERATED_PROJECT_PATH,
      _PUBSPEC_YAML_NAME,
      createFileIfNotFound: false,
    );
  }

  List<String> _addPackage(List<String> lines) {
    ///Appending the [package] in the [PUBSPEC_YAML_NAME] file.
    var depIndex = lines.indexOf('dependencies:') + 1;
    if (depIndex >= 0) {
      lines.insert(depIndex, '$package: $version');
    }

    ///Appending the images path into the [PUBSPEC_YAML_NAME] file.
    // TODO: we may want to move this to a separate Command to ensure it only gets called once.
    var assetIndex = lines.indexOf('  assets:') + 1;
    if (!lines.contains(_ASSET_DECLERATION) && assetIndex >= 0) {
      if (assetIndex == lines.length) {
        lines.add(_ASSET_DECLERATION);
      } else {
        lines.insert(assetIndex, _ASSET_DECLERATION);
      }
    }
    return lines;
  }
}
