import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:test/test.dart';

void main() {
  final projectName = 'golden_testing_project';
  final basePath = path.join(path.current, 'test', 'golden');
  final runtimeFilePath = path.join(basePath, projectName, 'lib');
  final goldenFilesPath = path.join(basePath, 'golden_files');
  group('Styling Golden Test', () {
    setUp(() async {
      // Run Parabeac core to generate test file
      await Process.run('dart', [
        'parabeac.dart',
        '-f',
        'AVFG9SWJOzJ4VAfM7uMVzr',
        '-k',
        '346172-e6b93eec-364f-4baa-bee8-24bf1e4d26da',
        '-n',
        '$projectName',
        '-o',
        '$basePath'
      ]);
    });
    test('Generating Styling and Comparing Golden File', () async {
      var goldenScreen = File(path.join(goldenFilesPath, 'styling.golden'));

      var runtimeFile = File(path.join(
          runtimeFilePath, 'screens', 'styling', 'styling_screen.g.dart'));

      var goldenScreenList = goldenScreen.readAsLinesSync();

      var runtimeList = runtimeFile.readAsLinesSync();

      // Compare screens line by line
      for (var i = 0; i < goldenScreenList.length; i++) {
        expect(runtimeList[i], goldenScreenList[i], reason: 'Line ${i + 1}');
      }
    });

    tearDown(() async {
      // Remove temporary project
      await Process.start('rm', ['-rf', path.join(basePath, projectName)]);
    });
  });
}
