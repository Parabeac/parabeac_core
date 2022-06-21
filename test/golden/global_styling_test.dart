import 'dart:io';

import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_services/domain_path_service.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  final projectName = 'golden_testing_project';
  final basePath = path.join(path.current, 'test', 'golden');
  final runtimeFilePath = path.join(basePath, projectName);
  final goldenFilesPath = path.join(basePath, 'golden_files', 'global_styling');

  group('Global Styling tests', () {
    setUpAll(() async {
      // Run Parabeac core to generate test file
      await Process.run('dart', [
        'parabeac.dart',
        '-f',
        '3jHbHBXrDr74CTceGwE63Q',
        '-k',
        '346172-e6b93eec-364f-4baa-bee8-24bf1e4d26da',
        '-n',
        '$projectName',
        '-o',
        '$basePath'
      ]);
    });

    /// Tests whether Global colors were generated as constants in the project.
    test('Testing Global Colors', () {
      final goldenFile =
          File(path.join(goldenFilesPath, 'styling_colors.golden'));
      final runtimeFile = File(path.join(
        runtimeFilePath,
        DomainPathService().constantsRelativePath,
        'golden_testing_project_colors.g.dart',
      ));
      expect(runtimeFile.readAsStringSync(), goldenFile.readAsStringSync());
    });

    /// Tests whether Global TextStyles were generated as constants in the project.
    test('Testing Global TextStyles', () {
      final goldenFile =
          File(path.join(goldenFilesPath, 'styling_text_styles.golden'));
      final runtimeFile = File(path.join(
        runtimeFilePath,
        DomainPathService().constantsRelativePath,
        'golden_testing_project_text_styles.g.dart',
      ));
      expect(runtimeFile.readAsStringSync(), goldenFile.readAsStringSync());
    });
    tearDownAll(() async {
      // Remove temporary project
      await Process.start('rm', ['-rf', path.join(basePath, projectName)]);
    });
  });
}
