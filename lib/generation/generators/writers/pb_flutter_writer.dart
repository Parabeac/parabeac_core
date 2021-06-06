import 'dart:io';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';

///Responsible for writing code into files in the desired folder structure
class PBFlutterWriter implements PBPageWriter {
  PBFlutterWriter._internal();

  static final PBFlutterWriter _instance = PBFlutterWriter._internal();

  factory PBFlutterWriter() => _instance;

  @override
  Map<String, String> dependencies = {};
  @override
  void addDependency(String packageName, String version) =>
      dependencies[packageName] = version;

  ///[fileAbsPath] should be the absolute path of the file
  @override
  void write(String code, String fileAbsPath) {
    File(fileAbsPath).createSync(recursive: true);
    var writer = File(fileAbsPath);
    writer.writeAsStringSync(code);
  }

  /// Appends [code] to the end of file located at [fileAbsPath].
  ///
  /// Creates the file if the file at [fileAbsPath] does not exist.
  @override
  void append(String code, String fileAbsPath) {
    var file = File(fileAbsPath);
    if (file.existsSync()) {
      file.writeAsStringSync(code, mode: FileMode.append);
    } else {
      write(code, fileAbsPath);
    }
  }

  /// Function that allows the rewriting of the main() method inside main.dart
  void rewriteMainFunction(String pathToMain, String code,
      {Set<FlutterImport> imports}) {
    var mainRead = File(pathToMain).readAsStringSync();
    var newMain = imports.join() +
        mainRead.replaceFirst(
            RegExp(r'void main\(\)\s*{(.*|\s*)*?}'), 'void main() {$code}');
    File(pathToMain).writeAsStringSync(newMain);
  }

  /// Creates a new `main.dart` file that starts the Flutter application at
  /// `homeName` and adds the import from `main.dart` to `relativeImportPath`.
  Future<void> writeMainScreenWithHome(
      String homeName, String pathToMain, FlutterImport import) async {
    var mainFile = File(pathToMain).openWrite(mode: FileMode.writeOnly);
    mainFile.write('''
import 'package:flutter/material.dart';
import '${import.toString()}';

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
      home: $homeName(),
    );
  }
}''');

    await mainFile.flush();
    await mainFile.close();
  }

  void submitDependencies(String yamlAbsPath) async {
    var line = 0;
    var readYaml = File(yamlAbsPath).readAsLinesSync();
    if (dependencies.isNotEmpty) {
      line = readYaml.indexOf('dependencies:');
      if (line > 0) {
        dependencies.forEach((packageName, version) {
          if (!readYaml.contains('  $packageName: $version')) {
            readYaml.insert(++line, '  $packageName: $version');
          }
        });

        dependencies.clear(); // Clear dependencies to prevent duplicates
      }
    }
    line = readYaml.indexOf('flutter:');
    if (line > 0) {
      if (!readYaml.contains('  assets:')) {
        readYaml.insert(++line, '  assets:\n    - assets/images/');
      }
    }
    var writeYaml = File(yamlAbsPath).openWrite(mode: FileMode.write);

    for (var i = 0; i < readYaml.length; ++i) {
      writeYaml.writeln(readYaml[i]);
    }
    await writeYaml.flush();
  }
}
