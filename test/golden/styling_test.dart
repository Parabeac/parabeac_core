import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  final projectName = 'golden_testing_project';
  final goldenFilePath = 'test/golden/golden_files/styling.golden';
  final runtimeFilePath =
      '../$projectName/lib/screens/styling/silver_screen.g.dart';
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
        '$projectName'
      ]);
    });
    test('Generating Styling and Comparing Golden File', () async {
      var goldenFile = File(goldenFilePath);

      var silverFile = File(runtimeFilePath);

      var goldenList = goldenFile.readAsLinesSync();

      var silverList = silverFile.readAsLinesSync();

      // Compare screens line by line
      for (var i = 0; i < goldenList.length; i++) {
        expect(goldenList[i], silverList[i]);
      }
    });

    tearDown(() async {
      // Remove temporal project
      await Process.start('rm', [
        '-rf',
        '../$projectName',
      ]);
    });
  });
}
