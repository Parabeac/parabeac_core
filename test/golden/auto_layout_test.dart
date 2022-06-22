import 'dart:io';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_services/domain_path_service.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  final projectName = 'golden_auto_layout_testing_project';
  final basePath = path.join(path.current, 'test', 'golden');
  final runtimeFilePath =
      path.join(basePath, projectName, DomainPathService().viewsRelativePath);
  final goldenFilesPath = path.join(basePath, 'golden_files', 'auto_layout');
  group('Auto Layout Golden Test', () {
    setUp(() async {
      // Run Parabeac core to generate test file
      await Process.run('dart', [
        'parabeac.dart',
        '-f',
        '9yfEiTTiE5hoyZeRTGopQd',
        '-k',
        '346172-e6b93eec-364f-4baa-bee8-24bf1e4d26da',
        '-n',
        '$projectName',
        '-o',
        '$basePath'
      ]);
    });
    test('Generating Auto Layout and Comparing Golden File', () async {
      /// Fetch a list with all the names for Auto Layout Golden Files
      final fileNames =
          File(path.join(goldenFilesPath, 'auto_layout_file_names.txt'));

      final goldenFiles = <File>[];
      final runtimeFiles = <File>[];

      var fileNamesLines = fileNames.readAsLinesSync();

      /// Add all files as golden files to the list
      /// Also add run time files to another list
      for (var i = 0; i < fileNamesLines.length; i++) {
        goldenFiles.add(
            File(path.join(goldenFilesPath, '${fileNamesLines[i]}.golden')));

        runtimeFiles.add(File(path.join(runtimeFilePath,
            'auto_layout_permutations', '${fileNamesLines[i]}.g.dart')));
      }

      /// Iterate through golden/runtime files and compare them
      for (var i = 0; i < goldenFiles.length; i++) {
        var goldenFile = goldenFiles[i];
        var runtimeFile = runtimeFiles[i];
        var goldenFileLines = goldenFile.readAsLinesSync();
        var runtimeFileLines = runtimeFile.readAsLinesSync();

        for (var j = 0; j < goldenFileLines.length; j++) {
          expect(runtimeFileLines[j], goldenFileLines[j],
              reason: 'File ${path.basename(goldenFile.path)} Line $j');
        }
      }
    }, timeout: Timeout(Duration(minutes: 5)));

    tearDown(() async {
      // Remove temporary project
      await Process.start('rm', ['-rf', path.join(basePath, projectName)]);
    });
  });
}
