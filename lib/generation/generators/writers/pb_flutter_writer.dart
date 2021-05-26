import 'dart:io';
import 'package:quick_log/quick_log.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/input/sketch/entities/style/font_descriptor.dart';

///Responsible for writing code into files in the desired folder structure
class PBFlutterWriter implements PBPageWriter {
  PBFlutterWriter._internal();

  static final PBFlutterWriter _instance = PBFlutterWriter._internal();

  factory PBFlutterWriter() => _instance;

  var log = Logger('PBFlutterWriter');
  @override
  Map<String, String> dependencies = {};

  @override
  Map<String, Map<String, FontDescriptor>> fonts = {};

  @override
  void addDependency(String packageName, String version) =>
      dependencies[packageName] = version;

  @override
  void addFont(FontDescriptor fd) {
    if (!fonts.containsKey(fd.fontFamily)) {
      fonts[fd.fontFamily] = {};
    }
    fonts[fd.fontFamily][fd.fontName] = fd;
  }

  ///[fileAbsPath] should be the absolute path of the file
  @override
  void write(String code, String fileAbsPath) {
    File(fileAbsPath).createSync(recursive: true);
    var writer = File(fileAbsPath);
    writer.writeAsStringSync(code);
  }

  /// Function that allows the rewriting of the main() method inside main.dart
  void rewriteMainFunction(String pathToMain, String code,
      {Set<String> imports}) {
    var mainRead = File(pathToMain).readAsStringSync();
    var newMain = imports.join() +
        mainRead.replaceFirst(
            RegExp(r'void main\(\)\s*{(.*|\s*)*?}'), 'void main() {$code}');
    File(pathToMain).writeAsStringSync(newMain);
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

  Future<void> submitDependencies(String yamlAbsPath) async {
    var line = 0;
    var readYaml = File(yamlAbsPath).readAsLinesSync();
    if (dependencies.isNotEmpty) {
      line = readYaml.indexOf('dependencies:');
      if (line >= 0) {
        dependencies.forEach((packageName, version) {
          if (!readYaml.contains('  ${packageName}: ${version}')) {
            readYaml.insert(++line, '  ${packageName}: ${version}');
          }
        });

        dependencies.clear(); // Clear dependencies to prevent duplicates
      }
    }
    line = readYaml.indexOf('flutter:');
    if (line >= 0) {
      if (!readYaml.contains('  assets:')) {
        readYaml.insert(++line, '  assets:\n    - assets/images/');
      }
    }

    // add any fonts to the .yaml file, end-user will need to copy the fonts to the directory
    if (fonts.isNotEmpty) {
      line = readYaml.indexOf('fonts:');
      if (line < 0) {
        readYaml.add('fonts:');
        line = readYaml.length - 1;
      }
      line++;
      fonts.forEach((fontFamily, fontNameMap) {
        var familyLine = readYaml.indexOf('  - family: $fontFamily');
        if (familyLine < 0) {
          familyLine = line;
          readYaml.insert(line, '  - family: $fontFamily');
        }
        // find the end of this yaml block for - family:
        var endFamilyLine = readYaml.indexWhere((element) =>
            element.startsWith('  - family: '), familyLine + 1);
        if (endFamilyLine < 0) {
          endFamilyLine = readYaml.length;
        }

        var fontsLine = readYaml.indexOf('    fonts:', familyLine);
        if ((fontsLine < 0) || (fontsLine >= endFamilyLine)) {
          fontsLine = familyLine + 1;
          readYaml.insert(fontsLine, '    fonts:');
        }

        // run through the actual font files to load
        fontNameMap.forEach((fontName, fd) {
          var fontPath = '${MainInfo().outputPath}${MainInfo().projectName}/assets/fonts/$fontFamily';
          if (!File('$fontPath/$fontName.ttf').existsSync()) {
            log.info('Please copy missing $fontName.ttf to $fontPath/');
          }

          var assetLine = readYaml.indexOf(
              '      - asset: fonts/$fontFamily/$fontName.ttf', familyLine);
          if ((assetLine < 0) || (assetLine >= endFamilyLine)) {
            readYaml.insert(
                ++fontsLine, '      - asset: fonts/$fontFamily/$fontName.ttf');
            // add weight but not w prefix that flutter requires.
            readYaml.insert(++fontsLine, '        weight: ${fd.fontWeight.substring(1)}');
            if (fd.fontStyle == 'italic') {
              readYaml.insert(++fontsLine, '        style: italic');
            }
          }
        });
      });
    }

    var writeYaml = File(yamlAbsPath).openWrite(mode: FileMode.write);

    for (var i = 0; i < readYaml.length; ++i) {
      writeYaml.writeln(readYaml[i]);
    }
    await writeYaml.flush();
  }
}
