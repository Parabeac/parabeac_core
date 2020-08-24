import 'dart:convert';
import 'dart:io';
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
