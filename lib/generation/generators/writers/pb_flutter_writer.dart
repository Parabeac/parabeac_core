import 'dart:io';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
import 'package:yaml_modify/yaml_modify.dart';

///Responsible for writing code into files in the desired folder structure
class PBFlutterWriter implements PBPageWriter {
  PBFlutterWriter._internal();

  static final PBFlutterWriter _instance = PBFlutterWriter._internal();

  factory PBFlutterWriter() => _instance;

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

  void submitDependencies(
      String yamlAbsPath, Map<String, String> dependencies) {
    var yamlStr = File(yamlAbsPath).readAsStringSync();
    var modifiableyaml = getModifiableNode(loadYaml(yamlStr)) as Map;

    /// Add new dependencies to pubspec.yaml
    if (dependencies.isNotEmpty && modifiableyaml.containsKey('dependencies')) {
      var yamlDeps = modifiableyaml['dependencies'] as Map;

      /// Check if dependency already exists.
      /// Add dependency if it does not exist already.
      dependencies.forEach((name, version) {
        if (!yamlDeps.containsKey(name)) {
          yamlDeps[name] = version;
        }
      });

      dependencies.clear();
    }

    /// Add assets
    var assets = _getAssetFileNames();
    if (modifiableyaml.containsKey('flutter') && assets.isNotEmpty) {
      /// Add only elements that are not already in the yaml
      if (modifiableyaml['flutter'].containsKey('assets') &&
          modifiableyaml['flutter']['assets'] != null) {
        var existingAssets = (modifiableyaml['flutter']['assets'] as List);
        assets.forEach((asset) {
          if (!existingAssets.any((e) => e.endsWith('/$asset'))) {
            existingAssets
                .add('packages/${MainInfo().projectName}/assets/images/$asset');
          }
        });
      }

      /// Add all elements to the yaml
      else {
        modifiableyaml['flutter']['assets'] = assets
            .map((e) => 'packages/${MainInfo().projectName}/assets/images/$e')
            .toList();
      }
    }

    /// Write the new yaml file
    File(yamlAbsPath)
        .writeAsStringSync(toYamlString(modifiableyaml).replaceAll(r'\n', ''));
  }

  /// Returns a [List<String>] of all the `filenames` of `pngs` listed under `assets/images/`
  List<String> _getAssetFileNames() {
    try {
      // Return names inside image reference storage
      return ImageReferenceStorage()
          .names
          .map((imageName) => '${imageName}')
          .toList();
    } catch (e) {
      return [];
    }
  }
}
