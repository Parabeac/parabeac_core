import 'dart:io';

import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

/// Command used to add a dependency to `pubspec.yaml`
class AddDependencyCommand extends FileStructureCommand {
  String package;
  String version;

  AddDependencyCommand(this.package, this.version);

  /// Appends `package` and `version` to `pubspec.yaml` dependencies.
  @override
  Future<void> write(FileStructureStrategy strategy) async {
    var yamlAbsPath = '${strategy.GENERATED_PROJECT_PATH}/pubspec.yaml';

    var readYaml = File(yamlAbsPath).readAsLinesSync();

    // Ensure dependency has not already been added
    if (readYaml.contains('$package: $version')) {
      return;
    }

    var line = readYaml.indexOf('dependencies:');
    readYaml.insert(++line, '\t$package: $version');

    // TODO: we may want to move this to a separate Command to ensure it only gets called once.
    line = readYaml.indexOf('flutter:');
    if (line > 0) {
      if (!readYaml.contains('  assets:')) {
        readYaml.insert(++line, '  assets:\n    - assets/images/');
      }
    }
    var buffer = StringBuffer();

    for (var line in readYaml) {
      buffer.writeln(line);
    }
    writeDataToFile(buffer.toString(), yamlAbsPath);
  }
}
