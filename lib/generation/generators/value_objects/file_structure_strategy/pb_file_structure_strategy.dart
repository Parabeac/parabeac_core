import 'dart:io';
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
import 'package:tuple/tuple.dart';

///Responsible for creating a particular file structure depending in the structure
///
///For example, in the provider strategy, there would be a directory for the models and the providers,
///while something like BLoC will assign a directory to a single.
///
/// The [FileStructureStrategy] can also perform a dry run of the all the [writeDataToFile] calls
/// that are going to be performed. This is useful for notifying the [FileWriterObserver]s of new files that
/// are being written into the file system without actually writing them into the system. The main purpose
/// of this functionality is mimicking the file creation to observers like the [ImportHelper] can record all of the imports.
abstract class FileStructureStrategy implements CommandInvoker {
  final Logger logger = Logger('FileStructureStrategy');

  ///The `default` path of where all the views are going to be generated.
  ///
  ///The views is anything that is not a screen, for example, symbol masters
  ///are going to be generated in this folder if not specified otherwise.
  final RELATIVE_VIEW_PATH = 'lib/widgets/';

  ///The `default` path of where all the screens are going to be generated.
  final RELATIVE_SCREEN_PATH = 'lib/screens/';

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

  /// The flag indicates when the [writeDataToFile] is going to mimic the creation
  /// of the files.
  ///
  /// If [_inDryRunMode] is `true`, then any file creation is going to be simulated and remain on
  /// hold on the [_dryRunMethodCalls] list. If you are running the [FileStructureStrategy] [_inDryRunMode], then
  /// make sure to run [writeDryRunCommands] at the end to execute all the recored [writeDataToFile] calls.
  bool _inDryRunMode = false;
  set inDryRunMode(bool dryRun) => _inDryRunMode = dryRun;

  /// The flag, if `true`, notifies all the [FileWriterObserver]s twice when a file is created (assuming that its running in [_inDryRunMode]).
  ///
  /// If you want to only notify the [FileWriterObserver]s when the actual file is created, then
  /// [_dryRunModeNotify] flag should be `false`
  bool _dryRunModeNotify;
  set dryRunModeNotify(bool notify) => _dryRunModeNotify = notify;

  List<Tuple4> _dryRunMethodCalls;

  String _screenDirectoryPath;
  String _viewDirectoryPath;

  FileStructureStrategy(
    this.GENERATED_PROJECT_PATH,
    this._pageWriter,
    this._pbProject,
  ) {
    _dryRunMethodCalls = [];
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
      _pbProject.forest.forEach((dir) {
        if (dir.rootNode != null) {
          addImportsInfo(dir);
        }
      });
      Directory(_screenDirectoryPath).createSync(recursive: true);
      Directory(_viewDirectoryPath).createSync(recursive: true);
      isSetUp = true;
    }
  }

  ///Add the import information to correctly generate them in the corresponding files.
  void addImportsInfo(PBIntermediateTree tree) {
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
            poLinker.stripPlatform(tree.rootNode.managerData.platform), name);
      }
      path = p.setExtension(path, '.dart');
      PBGenCache().setPathToCache(uuid, path);
    } else {
      logger.warning(
          'The following intermediateNode was missing a name: ${tree.toString()}');
    }
  }

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

  ///Going to run any [writeDataToFile] calls that just executed in [_inDryRunMode].
  void writeDryRunCommands() {
    _dryRunMethodCalls.forEach((funcParams) => writeDataToFile(
        funcParams.item1, funcParams.item2, funcParams.item3,
        UUID: funcParams.item4));
    _dryRunMethodCalls.clear();
  }

  void clearDryRunCommands() => _dryRunMethodCalls.clear();

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
  void writeDataToFile(String data, String directory, String name,
      {String UUID}) {
    var file = getFile(directory, name);

    if (_inDryRunMode) {
      _dryRunMethodCalls.add(Tuple4(data, directory, name, UUID));
      if (_dryRunModeNotify) {
        fileObservers.forEach((observer) => observer.fileCreated(
            file.path, UUID ?? p.basenameWithoutExtension(file.path)));
      }
    } else {
      file.createSync(recursive: true);
      file.writeAsStringSync(data);

      fileObservers.forEach((observer) => observer.fileCreated(
          file.path, UUID ?? p.basenameWithoutExtension(file.path)));
    }
  }

  /// Appends [data] into [directory] with the file [name]
  ///
  /// The method is going to be identical to [writeDataToFile], however,
  /// it going to try to append [data] to the file in the [directory]. If
  /// no file is found, then its going to run [writeDataToFile]. [appendIfFound] flag
  /// appends the information only if that information does not exist in the file. If no
  /// [ModFile] function is found, its going to append the information at the end of the lines
  void appendDataToFile(ModFile modFile, String directory, String name,
      {String UUID, bool createFileIfNotFound = true}) {
    var file = getFile(directory, name);
    if (file.existsSync()) {
      var fileLines = file.readAsLinesSync();
      var modLines = modFile(fileLines);

      if (fileLines != modLines) {
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
