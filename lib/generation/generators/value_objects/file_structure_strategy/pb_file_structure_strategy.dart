import 'dart:io';
import 'package:parabeac_core/generation/flutter_project_builder/file_system_analyzer.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:path/path.dart' as p;

import 'package:parabeac_core/generation/flutter_project_builder/file_writer_observer.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/command_invoker.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';
import 'package:quick_log/quick_log.dart';
import 'package:recase/recase.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

///Responsible for creating a particular file structure depending in the structure
///
///For example, in the provider strategy, there would be a directory for the models and the providers,
///while something like BLoC will assign a directory to a single.
///
abstract class FileStructureStrategy implements CommandInvoker {
  Logger logger;

  ///The `default` path of where all the views are going to be generated.
  ///
  ///The views is anything that is not a screen, for example, symbol masters
  ///are going to be generated in this folder if not specified otherwise.
  static final RELATIVE_VIEW_PATH = 'lib/widgets/';

  ///The `default` path of where all the screens are going to be generated.
  static final RELATIVE_SCREEN_PATH = 'lib/screens/';

  ///Path of where the project is generated
  final String GENERATED_PROJECT_PATH;

  @Deprecated(
      'Each of the methods should be receiving its own [PBProject] instance.')
  final PBProject _pbProject;

  @Deprecated(
      'We are now using the [FileStructureCommands] instead of the page Writter')
  final PBPageWriter _pageWriter;
  PBPageWriter get pageWriter => _pageWriter;

  ///[FileWriterObserver] are observers that are notified everytime a new file
  ///is created in the file in the file system
  ///
  ///A good example of an observer is the [ImportHelper], which keeps track
  ///of the files relative location to handle their imports.
  final List<FileWriterObserver> fileObservers = [];

  ///Indicator that signals if the required directories are constructed.
  ///
  ///Before generating any files, the caller must call the [setUpDirectories]
  bool isSetUp = false;

  /// By the [FileStructureStrategy] being in [dryRunMode], the [FileStructureStrategy] is not
  /// going to create anyFiles.
  ///
  /// Primarly, this mode is to notify the [fileObservers] of a "file creation", without performing
  /// the actual creation. A good example of this comes with the [ImportHelper], this oberserver will
  /// be documenting the files that are being created as imports to be used later.
  bool dryRunMode = false;

  /// Notifies the [fileObserver] of when a file supposed to be created.
  bool notifyObserverInDryRun = true;

  /// How the extension of the [File]s are going to be written based on the ownership of
  /// the [File].
  FileOwnershipPolicy fileOwnershipPolicy;

  /// Uses the [FileSystemAnalyzer] to see if certain [File]s aready exist in the file system.
  ///
  /// This is primarly used when checking [FileOwnership.DEV]'s [File]s in the files sytem to see if they exist.
  /// If they do exist, then PBC is not going to modify them, ignoring whatever modification towards the [File]
  /// that was comming through [writeDataToFile] (method that created the actual [File]s).
  FileSystemAnalyzer _fileSystemAnalyzer;

  String _screenDirectoryPath;
  String _viewDirectoryPath;

  FileStructureStrategy(this.GENERATED_PROJECT_PATH, this._pageWriter,
      this._pbProject, this._fileSystemAnalyzer,
      {this.fileOwnershipPolicy}) {
    logger = Logger(runtimeType.toString());
    if (_fileSystemAnalyzer == null) {
      logger.error(
          '$FileSystemAnalyzer is null, meaning there are no files indexed and all files are going to be created.');
      _fileSystemAnalyzer = FileSystemAnalyzer(GENERATED_PROJECT_PATH);
    }
    fileOwnershipPolicy ??= DotGFileOwnershipPolicy();
  }

  void addFileObserver(FileWriterObserver observer) {
    if (observer != null) {
      fileObservers.add(observer);
    }
  }

  ///Setting up the required directories for the [FileStructureStrategy] to write the corresponding files.
  ///
  ///Default directories that are going to be generated is the
  ///[RELATIVE_VIEW_PATH] and [RELATIVE_SCREEN_PATH].
  Future<void> setUpDirectories() async {
    if (!isSetUp) {
      _screenDirectoryPath =
          p.join(GENERATED_PROJECT_PATH, RELATIVE_SCREEN_PATH);
      _viewDirectoryPath = p.join(GENERATED_PROJECT_PATH, RELATIVE_VIEW_PATH);
      // _pbProject.forest.forEach((dir) {
      //   if (dir.rootNode != null) {
      //     addImportsInfo(dir, context);
      //   }
      // });
      Directory(_screenDirectoryPath).createSync(recursive: true);
      Directory(_viewDirectoryPath).createSync(recursive: true);
      isSetUp = true;
    }
  }

  ///Add the import information to correctly generate them in the corresponding files.
  void addImportsInfo(PBIntermediateTree tree, PBContext context) {
    var poLinker = PBPlatformOrientationLinkerService();
    // Add to cache if node is scaffold or symbol master
    var node = tree.rootNode;
    var name = node?.name?.snakeCase;
    if (name != null) {
      var uuid = node is PBSharedMasterNode ? node.SYMBOL_ID : node.UUID;
      var path = node is PBSharedMasterNode
          ? p.join(_viewDirectoryPath, tree.name.snakeCase, name)
          : p.join(_screenDirectoryPath, tree.name.snakeCase, name);
      if (poLinker.screenHasMultiplePlatforms(tree.rootNode.name)) {
        path = p.join(_screenDirectoryPath, name,
            poLinker.stripPlatform(context.managerData.platform), name);
      }

      PBGenCache().setPathToCache(uuid, path);
    } else {
      logger.warning(
          'The following intermediateNode was missing a name: ${tree.toString()}');
    }
  }

  @Deprecated('Please use the method [writeDataToFile] to write into the files')

  ///Writing the code to the actual file
  ///
  ///The default computation of the function will foward the `code` to the
  ///`_pageWriter`. The [PBPageWriter] will then generate the file with the code inside
  Future<void> generatePage(String code, String fileName, {var args}) {
    if (args is String) {
      var path = args == 'SCREEN'
          ? p.join(_screenDirectoryPath, fileName)
          : p.join(_viewDirectoryPath, fileName);
      pageWriter.write(code, p.setExtension(path, '.dart'));
    }
    return Future.value();
  }

  String getViewPath(String fileName) =>
      p.setExtension(p.join(_viewDirectoryPath, fileName), '.dart');

  @override
  void commandCreated(FileStructureCommand command) {
    command.write(this);
  }

  /// Writing [data] into [directory] with the file [name]
  ///
  /// The [name] parameter should include the name of the file and the
  /// extension of the file. For example, the [directory] 'temp/' contains
  /// the file [name] of 'example.txt'.
  /// The [UUID] is unique identifier of the file created in the [directory].
  /// If no [UUID] is specified, the [p.basenameWithoutExtension(path)] will
  /// be used.
  ///
  /// [FileWriterObserver]s are going to be notfied of the new created file.
  /// TODO: aggregate parameters into a file class
  void writeDataToFile(String data, String directory, String name,
      {String UUID, FileOwnership ownership, String ext = '.dart'}) {
    var file = getFile(
        directory,
        p.setExtension(
            name, fileOwnershipPolicy.getFileExtension(ownership, ext)));

    if (_fileSystemAnalyzer.containsFile(file.path) &&
        ownership == FileOwnership.DEV) {
      /// file is going to be ignored
      logger.fine(
          'File $name has been ignored as is already present in the project');
      return;
    }

    if (!dryRunMode) {
      file.createSync(recursive: true);
      file.writeAsStringSync(data);
      _notifyObservers(file.path, UUID);
    } else if (notifyObserverInDryRun) {
      _notifyObservers(file.path, UUID);
    }
  }

  void _notifyObservers(String path, String UUID) {
    fileObservers.forEach((observer) => observer.fileCreated(path, UUID));
  }

  /// Appends [data] into [directory] with the file [name]
  ///
  /// The method is going to be identical to [writeDataToFile], however,
  /// it going to try to append [data] to the file in the [directory]. If
  /// no file is found, then its going to run [writeDataToFile]. [appendIfFound] flag
  /// appends the information only if that information does not exist in the file. If no
  /// [ModFile] function is found, its going to append the information at the end of the lines
  /// TODO: aggregate the parameters into a file class
  void appendDataToFile(ModFile modFile, String directory, String name,
      {String UUID,
      bool createFileIfNotFound = true,
      String ext = '.dart',
      FileOwnership ownership}) {
    name = ownership == null
        ? p.setExtension(name, ext)
        : p.setExtension(
            name, fileOwnershipPolicy.getFileExtension(ownership, ext));
    var file = getFile(directory, name);
    if (file.existsSync()) {
      var fileLines = file.readAsLinesSync();
      var length = fileLines.length;
      var modLines = modFile(fileLines);

      if (modLines.length != length) {
        var buffer = StringBuffer();
        modLines.forEach(buffer.writeln);
        file.writeAsStringSync(buffer.toString());
      }
    } else if (createFileIfNotFound) {
      var modLines = modFile([]);
      var buffer = StringBuffer();
      modLines.forEach(buffer.writeln);
      writeDataToFile(buffer.toString(), directory, name, UUID: UUID);
    }
  }

  File getFile(String directory, String name) => File(p.join(directory, name));
}

/// [Function] that returns the modified [lines] that should make the new data.
///
/// _If the lines is empty, make sure you still return the data to be added, specially
/// if the file is going to be create._
///
/// This is used to insert data into an existing file in a specified location.
/// For example, when inserting a dart package into the `pubspec.yaml` file, the [ModFile]
/// [Function] is going to return the `List<String>` that includes the new data.
typedef ModFile = List<String> Function(List<String> lines);
