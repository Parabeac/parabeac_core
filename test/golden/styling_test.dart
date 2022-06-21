import 'dart:io';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_services/domain_path_service.dart';
import 'package:path/path.dart' as path;

import 'package:test/test.dart';

void main() {
  final projectName = 'styling_golden_testing_project';
  final basePath = path.join(path.current, 'test', 'golden');
  final runtimeFilePath = path.join(basePath, projectName);
  final goldenFilesPath = path.join(basePath, 'golden_files', 'styling');
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
    test(
      'Generating Styling and Comparing Golden File',
      () async {
        /// Screen containing styling frames and rectangles
        final goldenScreen = File(path.join(goldenFilesPath, 'styling.golden'));

        /// Empty frame containing single text that says "Hello World"
        final helloWorldFrame =
            File(path.join(goldenFilesPath, 'helloworld.golden'));

        /// Component that uses Color grouping directly on the component.
        final primaryButton =
            File(path.join(goldenFilesPath, 'primary_button.golden'));

        /// Component that uses Color grouping through a rectangle inside the component.
        final primaryButtonRect =
            File(path.join(goldenFilesPath, 'primary_button_rect.golden'));

        /// Component that uses a secondary Color grouping directly on the component.
        final secondaryButton =
            File(path.join(goldenFilesPath, 'secondary_button.golden'));
        final goldenFiles = <File>[
          goldenScreen,
          helloWorldFrame,
          primaryButton,
          primaryButtonRect,
          secondaryButton
        ];

        /// Runtime files corresponding to the above golden files
        final widgetPath = path.join(
          runtimeFilePath,
          DomainPathService().widgetsRelativePath,
          'styling',
        );
        final runtimeFile = File(path.join(
          runtimeFilePath,
          DomainPathService().viewsRelativePath,
          'styling',
          'styling_screen.g.dart',
        ));
        final helloWorldRuntimeFile =
            File(path.join(widgetPath, 'helloworld.g.dart'));
        final primaryButtonRuntimeFile =
            File(path.join(widgetPath, 'primary_button.g.dart'));
        final primaryButtonRectRuntimeFile =
            File(path.join(widgetPath, 'primary_button_rect.g.dart'));
        final secondaryButtonRuntimeFile =
            File(path.join(widgetPath, 'secondary_button.g.dart'));
        final runtimeFiles = <File>[
          runtimeFile,
          helloWorldRuntimeFile,
          primaryButtonRuntimeFile,
          primaryButtonRectRuntimeFile,
          secondaryButtonRuntimeFile
        ];

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
      },
      timeout: Timeout(Duration(minutes: 1)),
    );

    tearDown(() async {
      // Remove temporary project
      await Process.start('rm', ['-rf', path.join(basePath, projectName)]);
    });
  });
}
