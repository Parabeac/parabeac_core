import 'package:file/local.dart';
import 'package:path/path.dart' as p;
import 'package:file/file.dart';
import 'package:quick_log/quick_log.dart';

/// The [FileSystemAnalyser]'s main purpose is enable the continous modification
/// of dart files in a particular directory.
///
/// This is done by keeping track of the [File]s that are within the [projectPath].
/// These paths are going to be used by other components in Parabeac-Core to see if
/// those files should be replaced or non touched.
///
/// Parabeac-Core is going to follow the convention of many code-generating packages, of
/// encapsulating their code changes in files with a `.g.dart` appended to their [File]. Furthermore,
/// Parabeac-Core also might generate some non`.g.dart`(e.g. `example.dart`) files the first time,
/// as boilerplate for the developer.
class FileSystemAnalyzer {
  Logger _logger;

  /// Had to expose use the `file` dart package and expose the
  /// [FileSystem] in order to perform some testing in the [FileSystemAnalyzer].
  FileSystem fileSystem;

  /// A set that contains multiple paths
  p.PathSet _pathSet;
  List<String> get paths => _pathSet.toList();

  /// Path of where the project [Directory] is located.
  String _projectPath;
  String get projectPath => _projectPath;

  /// The actual [Directory] of [projectPath]
  Directory _projectDir;

  /// Flag to see if project exist, mainly so we dont run [projectExist] multiple
  /// times.
  bool _projectChecked = false;

  FileSystemAnalyzer(String projectPath, {this.fileSystem}) {
    assert(projectPath != null);

    _logger = Logger(runtimeType.toString());
    fileSystem ??= LocalFileSystem();

    _projectPath = p.normalize(projectPath);
    _pathSet = p.PathSet(context: p.Context());
  }

  bool containsFile(String path) {
    if (path == null) {
      throw NullThrownError();
    }
    return _pathSet.contains(p.normalize(path));
  }

  /// returns if a [Directory] is present on the path of [_projectPath]
  Future<bool> projectExist() {
    return fileSystem.isDirectory(_projectPath).then((isDirectory) {
      _projectChecked = true;
      if (isDirectory) {
        _projectDir = fileSystem.directory(_projectPath);
      } else {
        _logger.info(
            'The $_projectPath does not exist or its not of type Directory.');
      }
      return isDirectory;
    });
  }

  /// From the [_projectPath] provided, we are going to scan all the files within and
  /// save them in [_pathSet]
  Future<void> indexProjectFiles() async {
    if (!_projectChecked) {
      await projectExist();
    }
    if (_projectDir == null) {
      throw FileSystemException('There is no project directory present');
    }

    /// Traverse the files of the directory
    _logger.info('Indexing files within $projectPath...');
    var filePaths = await _projectDir
        .list(recursive: true, followLinks: false)
        .where((entity) => entity is File)
        .cast<File>()
        .map<String>((File file) => p.normalize(file.path))
        .toList();
    _logger.info('Completed indexing files');

    _pathSet.addAll(filePaths);
  }
}
