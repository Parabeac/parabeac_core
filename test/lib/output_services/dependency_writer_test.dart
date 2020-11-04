import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_writer.dart';

void main() {
  group('Dependency writer test', () {
    var writer;
    // TODO: look for a yaml to modify that will not afect anything
    var yamlAbsPath = '${Directory.current.path}/temp/pubspec.yaml';
    setUp(() {
      writer = PBFlutterWriter();
      writer.addDependency('http_parser', '^3.1.4');
      writer.addDependency('shelf_proxy', '^0.1.0+7');
    });
    test('Dependency writer test', () async {
      await writer.submitDependencies(yamlAbsPath);
      var lineHttp = -1;
      var lineShelf = -1;
      var readYaml = await File(yamlAbsPath).readAsLinesSync();
      lineHttp = await readYaml.indexOf('  http_parser: ^3.1.4');
      lineShelf = await readYaml.indexOf('  shelf_proxy: ^0.1.0+7');
      expect(lineHttp >= 0, true);
      expect(lineShelf >= 0, true);

      var writeYaml = File(yamlAbsPath).openWrite(mode: FileMode.write);

      for (var i = 0; i < readYaml.length; ++i) {
        if (i == lineHttp || i == lineShelf) {
        } else {
          writeYaml.writeln(readYaml[i]);
        }
      }
      await writeYaml.flush();
    });
  });
}
