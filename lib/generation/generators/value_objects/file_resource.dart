import 'dart:io';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:path/path.dart' as p;
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';

/// Represents a wrapper to a [File] that is going to be written in the File System
class FileResource {
  /// Unique Identifier to the [FileResource]
  String UUID;

  /// The parent directory that the [file] is located at.
  String dirName;

  /// The basename of the [file]
  String fileName;

  /// The file extension for [file]
  String fileExtension;

  /// The path for the [file]
  String path;

  FileOwnership ownership;

  FileStructureStrategy fileSystem;

  File get file => _file;
  File _file;

  FileResource(
      {this.UUID,
      this.dirName,
      this.fileName,
      this.path,
      this.fileExtension = '.dart',
      this.fileSystem,
      File file}) {
    assert(
        (dirName == null && fileName == null) && path == null || file == null,
        'Either the [dirName] & [fileName] or [path] should be specified and not null');
    if (path != null) {
      dirName = p.dirname(path);
      fileName = p.basename(path);

      var extInPath = p.extension(path);
      if (extInPath != null || extInPath.isNotEmpty) {
        fileExtension = extInPath;
      }
    } else if (file != null) {
      fileName = p.basename(file.path);
      dirName = p.dirname(file.path);
      fileExtension = p.extension(file.path);
    } else {
      path = p.join(dirName, fileName, fileExtension);
    }
  }

  void _constructFile() {}

  void resolveFileExtension({FileOwnershipPolicy policy}) {
    assert(policy != null && fileSystem != null,
        'No way of resolving the file extension with null $policy and $FileStructureStrategy');
  }
}
