import 'package:file/file.dart';

/// Policy that tells the caller what [File] extension to use depending of
/// the [File]'s [FileOwnership].
///
/// For example, if the [File] is own by the developer, then we are going
/// to use the extension for [FileOwnership.DEV]; vice versa with [FileOwnership.PBC]. This
/// is primarly used when creating the [File]s, depicting if a [File] is going to
/// be manipulated by the developer or the Parabeac-Core system. It prevents the
/// accidental deletion of any of the users writing code in the central location.
abstract class FileOwnershipPolicy {
  /// The extension the developer own [File]s are going to have.
  FileOwnership fileOwnership;

  /// Based on the [ownership], its going to return the proper [File] extension.
  String getFileExtension(FileOwnership ownership);
}

/// The possible [FileOwnership] that could exist at once.
enum FileOwnership { DEV, PBC }

/// Exception regarding the [FileOwnershipPolicy]
class FileOwnershipPolicyError extends IOException {
  final String message;

  FileOwnershipPolicyError(this.message);

  @override
  String toString() => message;
}

/// This [FileOwnershipPolicy] enforces the developer own files to have the `.dart` extension,
/// while the Parabeac-Core own files with the `.g.dart` extension.
class DotGFileOwnershipPolicy implements FileOwnershipPolicy {
  @override
  FileOwnership fileOwnership;

  @override
  String getFileExtension(FileOwnership ownership) {
    switch (ownership) {
      case FileOwnership.DEV:
        return '.dart';
      case FileOwnership.PBC:
      default:
        return '.g.dart';
    }
  }
}
