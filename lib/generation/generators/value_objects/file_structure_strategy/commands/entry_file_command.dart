import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/node_file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:path/path.dart' as p;

/// [FileStructureCommand] used towrite the internals of the entry file.
///
/// For example, the modifying the code for `main.dart`, modifying the first screen
/// or adding/removing the imports, etc.
class EntryFileCommand extends NodeFileStructureCommand {
  ///The name for the file that is the entry point for the flutter application.
  final String mainFileName;

  /// The name of the screen that is going to act as the entry point within the [mainFileName]
  final String entryScreenName;

  /// The import for [entryScreenName]
  final String entryScreenImport;

  /// The name of the application as a whole. If no name is specified, the its going to default to
  /// `Parabeac-Core Generated Project`.
  final String projectName;

  /// The code of the main() method inside [mainFileName]
  final String mainCode;

  EntryFileCommand(
      {this.mainFileName = 'main',
      this.entryScreenName,
      this.entryScreenImport,
      this.projectName = 'Parabeac-Core Generated Project',
      this.mainCode = 'runApp(MyApp());',
      FileOwnership ownership = FileOwnership.DEV})
      : super(
            'ENTRY_FILE',
            '''
import 'package:flutter/material.dart';
$entryScreenImport

void main() {
    $mainCode
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$projectName',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: $entryScreenName(),
    );
  }
}
  
  ''',
            ownership) {
    if ((entryScreenImport == null && entryScreenName != null) ||
        (entryScreenName == null && entryScreenName != null)) {
      throw NullThrownError();
    }
  }

  @override
  Future write(FileStructureStrategy strategy) {
    strategy.writeDataToFile(
        code, strategy.GENERATED_PROJECT_PATH, p.join('lib', mainFileName),
        UUID: UUID, ownership: ownership);
  }
}
