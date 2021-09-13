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

  /// These are the extensions that should be indexed, if the [Set] is empty then, its
  /// going to assume that all the files should be indexed.
  ///
  /// For example, [_extensions] contains `.dart`, then only the `dart` files are going
  /// to be indexed. In other words, we are only going to care if `dart` files have been changed or
  /// missing.
  Iterable<String> get extensions => _extensions.toList();
  Set<String> _extensions;

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
    _extensions = <String>{};

    _projectPath = p.normalize(projectPath);
    _pathSet = p.PathSet(context: p.Context());
  }

  bool containsFile(String path) {
    if (path == null) {
      throw NullThrownError();
    }
    return _pathSet.contains(p.normalize(path));
  }

  /// Adding [ext] to the files that should be taken into consideration when
  /// running [indexProjectFiles].
  ///
  /// [level] represents 'how many dots from the end, for example, [level] of
  /// `1` could return `.dart` from `.g.dart`, [level] `2` would return `.g.dart`
  void addFileExtension(String ext, [int level = 1]) {
    if (ext != null) {
      /// [ext] could just be `.dart` in which case [p.extension] would return and empty string,
      /// therefore, we have to check if its just the raw extension or not.
      ext = ext.startsWith('.') ? ext : p.extension(ext, level);
      _extensions.add(ext);
    }
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

  /// From the [_projectPath] provided, we are going to scan all the [File]s within and
  /// save them in [_pathSet].
  ///
  /// All the [File]s are going to be indexed if [_extensions.isEmpty], if not, only the [File]s
  /// that contain any extension of [extension] within [File.path].
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
        .where((entity) =>
            entity is File &&
            (_extensions.isEmpty ||
                _extensions.any((ext) => entity.path.contains(ext))))
        .cast<File>()
        .map<String>((File file) => p.normalize(file.path))
        .toList();
    _logger.info('Completed indexing files');

    _pathSet.addAll(filePaths);
  }
}
