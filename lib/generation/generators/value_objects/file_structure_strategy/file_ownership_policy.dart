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

  /// Based on the [ownership], its going to return the proper [File] extension. This is
  /// done by modifying the [existingExtension] because its better to assume that the [File]
  /// extension is not going to be the same forever. Might be only `.dart` right now, but it
  /// could easily support `.json` tomorrow.
  String getFileExtension(FileOwnership ownership, String existingExtension);
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

/// This [IOException] is thrown when the wrong [File] extension(or something unexpected)
///  is given to the [FileOwnershipPolicy.getFileExtension].
class FileWrongExtensionFormat extends IOException {
  final String message;

  FileWrongExtensionFormat(this.message);
  @override
  String toString() => message;
}

/// This [FileOwnershipPolicy] enforces the developer own files to have the `.dart` extension,
/// while the Parabeac-Core own files with the `.g.dart` extension.
class DotGFileOwnershipPolicy implements FileOwnershipPolicy {
  @override
  FileOwnership fileOwnership;

  @override
  String getFileExtension(FileOwnership ownership, String existingExtension) {
    if (!existingExtension.startsWith('.')) {
      throw FileWrongExtensionFormat(
          'Wrong extension of $existingExtension given to $runtimeType, it only supports extensions starting with \'.\'');
    }
    if (ownership == FileOwnership.DEV) {
      return existingExtension;
    }

    var modExt = '.g' + existingExtension;
    return modExt;
  }
}
