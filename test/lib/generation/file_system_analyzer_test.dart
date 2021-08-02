import 'dart:async';

import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:parabeac_core/generation/flutter_project_builder/file_system_analyzer.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('$FileSystemAnalyzer functions on the current FileSystem', () {
    /// Stream used to expose the [FileSystem.opHandle] constructor method
    /// to al the test that might want to use it.
    StreamController<FileSystemOp> fileSystemUpdates;
    FileSystemAnalyzer fileSystemAnalyzer;
    FileSystem fileSystem;
    final projectPath = 'Path/to/project/';
    setUp(() async {
      ///contexting
      fileSystemUpdates = StreamController<FileSystemOp>.broadcast();
      fileSystem = MemoryFileSystem.test(
          opHandle: (context, operation) => fileSystemUpdates.add(operation));
      await fileSystem.currentDirectory
          .childDirectory(projectPath)
          .create(recursive: true);

      fileSystemAnalyzer =
          FileSystemAnalyzer(projectPath, fileSystem: fileSystem);
    });

    test(
        '$FileSystemAnalyzer checking for the existince of a project directory',
        () async {
      /// create some files within the [projectPath] that we can test the indexing of its files.
      var isProjectAvailable = await fileSystemAnalyzer.projectExist();
      expect(isProjectAvailable, true);
    });

    test(
        '$FileSystemAnalyzer indexing files within the project path that is passed to it.',
        () async {
      var cDir = fileSystem.currentDirectory;
      var files = <String>[
        './example_directory/some_file.dart',
        './parabeac_file.g.dart',
        './inside/multiple/directories/inside.dart',
        './testing_extension/should_be_ignored.txt'
      ].map((file) => p.join(projectPath, p.normalize(file)));

      /// Setting up the files within the [fileSystem.currentDirectory]
      files.forEach((file) {
        cDir.childFile(file).createSync(recursive: true);
      });

      /// [fileSystemAnalyzer] should strip anything that is not the actual file extension
      fileSystemAnalyzer.addFileExtension('extension.dart');
      expect(fileSystemAnalyzer.extensions.contains('.dart'), true);

      await fileSystemAnalyzer.indexProjectFiles();

      expect((files.length - 1), fileSystemAnalyzer.paths.length,
          reason:
              '$FileSystemAnalyzer should contain one less than the number of files because of the extension filter we set (.dart files).');
      fileSystemAnalyzer.paths.forEach((indexedFile) {
        var pathFound = files.contains(indexedFile);
        expect(pathFound, true,
            reason:
                '$FileSystemAnalyzer should index all of the files within directory');
      });
    });
  });
}
