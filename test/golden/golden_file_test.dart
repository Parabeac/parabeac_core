import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  group('Golden File Test Group', () {
    var projectName = 'golden_testing_project';
    setUp(() async {
      // Run Parabeac core to generate test file
      var parabeaccore = await Process.start('dart', [
        'parabeac.dart',
        '-f',
        'AVFG9SWJOzJ4VAfM7uMVzr',
        '-k',
        '346172-e6b93eec-364f-4baa-bee8-24bf1e4d26da',
        '-n',
        '$projectName'
      ]);

      // Await for output so it has time to create screens
      await for (var event in parabeaccore.stdout.transform(utf8.decoder)) {
        print(event);
      }
      await for (var event in parabeaccore.stderr.transform(utf8.decoder)) {
        print(event);
      }
    });
    test('Golden File Test', () async {
      var goldenFile = File('test/lib/golden/golden_file.txt');

      var silverFile =
          File('../$projectName/lib/screens/styling/silver_screen.g.dart');

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
