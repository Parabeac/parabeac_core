import 'dart:io';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/pb_page_writer.dart';

class PBFlutterWriter implements PBPageWriter {
  @override
  Map<String, String> dependencies = {};
  @override
  void addDependency(String packageName, String version) =>
      dependencies[packageName] = version;

  ///[fileAbsPath] should be the absolute path of the file
  @override
  void write(String code, String fileAbsPath) {
    File(fileAbsPath).createSync();
    var writer = File(fileAbsPath);
    writer.writeAsStringSync(code);
  }

  /// Creates a new `main.dart` file that starts the Flutter application at
  /// `homeName` and adds the import from `main.dart` to `relativeImportPath`.
  Future<void> writeMainScreenWithHome(
      String homeName, String pathToMain, String relativeImportPath) async {
    var mainFile = File(pathToMain).openWrite(mode: FileMode.writeOnly);
    mainFile.write('''
import 'package:flutter/material.dart';
import '$relativeImportPath';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${MainInfo().projectName ?? 'Parabeac-Core Generated Project'}',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ${homeName}(),
    );
  }
}''');

    await mainFile.flush();
    await mainFile.close();
  }

  void submitDependencies(String yamlAbsPath) async {
    var line = 0;
    if (dependencies.isNotEmpty) {
      var readYaml = File(yamlAbsPath).readAsLinesSync();

      line = readYaml.indexOf('dependencies:');
      if (line > 0) {
        dependencies.forEach((packageName, version) {
          readYaml.insert(++line, '  ${packageName}: ${version}');
        });

        var writeYaml = File(yamlAbsPath).openWrite(mode: FileMode.write);

        for (var i = 0; i < readYaml.length; ++i) {
          writeYaml.writeln(readYaml[i]);
        }
        await writeYaml.flush();
      }
    }
  }
}
