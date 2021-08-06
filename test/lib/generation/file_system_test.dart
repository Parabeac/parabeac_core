import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:parabeac_core/generation/flutter_project_builder/file_system_analyzer.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_screen_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;

class FileSystemAnalyzerMock extends Mock implements FileSystemAnalyzer {}

class FileMock extends Mock implements File {
  @override
  String path;
}

class PageWriterMock extends Mock implements PBPageWriter {}

class ProjectMock extends Mock implements PBProject {}

/// Its a [FileStructureStrategy] deticated for testing some of the methods for [FileStructureStrategy], as
/// I can not just use [Mock] on a particular methods [FileStructureStrategy.getFile].
class FileStructureSystemMock extends FileStructureStrategy {
  final FileMock file;
  final FileSystemAnalyzer analyzer;
  String path;
  FileStructureSystemMock(String GENERATED_PROJECT_PATH,
      PBPageWriter pageWriter, PBProject pbProject, this.file, this.analyzer)
      : super(GENERATED_PROJECT_PATH, pageWriter, pbProject, analyzer);

  @override
  File getFile(String directory, String name) {
    file.path = p.join(directory, name);
    return file;
  }
}

void main() {
  group(
      '$FileOwnershipPolicy returning the proper extension given an existing file extension',
      () {
    String existingFileExtension;
    FileOwnershipPolicy ownershipPolicy;
    setUp(() {
      ownershipPolicy = DotGFileOwnershipPolicy();
    });

    test('Testing the .g extension modification', () {
      existingFileExtension = '.dart';
      var extDevFile = existingFileExtension;
      var pbcDevFile = '.g$existingFileExtension';

      var reasonMessage = (actualExt, ownership, correctExt) =>
          'Not returning the correct file extension ($correctExt) when its $ownership own by passing $actualExt';

      var actualDevExt = ownershipPolicy.getFileExtension(
          FileOwnership.DEV, existingFileExtension);
      expect(actualDevExt, extDevFile,
          reason: reasonMessage(actualDevExt, FileOwnership.DEV, extDevFile));

      var actualPBCExt = ownershipPolicy.getFileExtension(
          FileOwnership.PBC, existingFileExtension);
      expect(actualPBCExt, pbcDevFile,
          reason: reasonMessage(
              actualPBCExt, FileOwnership.PBC, existingFileExtension));
    });
  });

  group(
      '$FileStructureStrategy only re-writing files that are [${FileOwnership.PBC}] owned and only once for [${FileOwnership.DEV}]',
      () {
    final generatedProjectPath = '/GeneratedProjectPath/';
    FileSystemAnalyzer analyzer;
    FileStructureStrategy fileStructureStrategy;
    File fileMock;

    /// Simple function to [verify] the arguments or call count of calling
    /// [File.writeAsStringSync].
    ///
    /// Because of no calls to a method and calling [verify] will cause an error, therefore,
    /// if the caller of the [commandVerification] funciton expects no calls, then it would have to pass
    /// `true` for [noCalls]. This flag will force the function to call [verifyNever] instead of [verify]
    var commandVerification =
        (List<String> paths, FileOwnership ownership, {bool noCalls = false}) {
      reset(fileMock);
      paths.forEach((path) {
        var baseName = p.basename(path);
        var ext = p.extension(path);

        /// Files like `.gitignore` are going to be evaluated to [ext.isEmpty] by [p.extension],
        /// therefore, I am padding the [baseName]
        ext = ext.isEmpty ? baseName : ext;

        var command = WriteScreenCommand('UUID_$baseName',
            baseName == ext ? '' : baseName, p.dirname(path), 'CODE_$baseName',
            ownership: ownership, fileExtension: ext);
        fileStructureStrategy.commandCreated(command);
      });
      return noCalls
          ? verifyNever(fileMock.writeAsStringSync(any))
          : verify(fileMock.writeAsStringSync(any));
    };

    var devFiles = [
      './some_dev_files/dev_file.dart',
      './other_dev_files/main.dart',
      './random_dev_files/readme.md',
      './random_dev_files/.gitignore',
    ];

    var pbcFiles = [
      './files_to_replace/another_depth/screen_one.g.dart',
      './files_to_replace/another_depth/screen_two.g.dart'
    ];

    /// Contains both the [devFiles] and the [pbcFiles].
    List<String> existingFiles;
    setUp(() {
      /// Adding the [generatedProjectPath] to [devFiles] & [pbcFiles].
      var addingGenProjectPath =
          (path) => p.normalize(p.join(generatedProjectPath, path));
      pbcFiles = pbcFiles.map(addingGenProjectPath).toList();
      devFiles = devFiles.map(addingGenProjectPath).toList();

      existingFiles = pbcFiles + devFiles;
      analyzer = FileSystemAnalyzerMock();

      fileMock = FileMock();
      fileStructureStrategy = FileStructureSystemMock(generatedProjectPath,
          PageWriterMock(), ProjectMock(), fileMock, analyzer);

      when(analyzer.paths).thenReturn(existingFiles);
      when(analyzer.containsFile(any)).thenAnswer((realInvocation) =>
          existingFiles.contains(realInvocation.positionalArguments.first));
    });

    test('$FileStructureStrategy replacing only [${FileOwnership.PBC}]', () {
      var verification = commandVerification(pbcFiles, FileOwnership.PBC);
      expect(verification.callCount, pbcFiles.length,
          reason:
              '$FileStructureStrategy did not replace the correct amount of files (${devFiles.length}), it only replaced ${verification.callCount}');
    });

    test(
        '$FileStructureStrategy not replacing [${FileOwnership.DEV}] owned files',
        () {
      var verification =
          commandVerification(devFiles, FileOwnership.DEV, noCalls: true);
      expect(verification.callCount, 0,
          reason:
              '$FileStructureStrategy should not be able to replace the ${FileOwnership.DEV} files, which its doing.');
    });
  });
}
