import 'package:_fe_analyzer_shared/src/scanner/token.dart';

/// This class verifies that the provided project name is in line with the Dart
/// Pubspec [format](https://dart.dev/tools/pub/pubspec#name)
/// using the official linter package from Dart.
///
/// The purpose of this class is to validate project names ahead of `flutter create`
/// in order properly handle errors.
///
class ProjectNameValidator {
  /// Directly use Regex and Identifiers from linter and analyzer packages
  /// to avoid analyzer version conflicts
  // Regex for enforcing project name naming format
  final _lowerCaseUnderScoreWithLeadingUnderscores =
      RegExp(r'^(_)*([a-z]+([_]?[a-z0-9]+)*)+$');
  final _identifier = RegExp(r'^([(_|$)a-zA-Z]+([_a-zA-Z0-9])*)$');

  bool isValidDartIdentifier(String id) =>
      !Keyword.keywords.keys.contains(id) && _identifier.hasMatch(id);
  // PB's naming deny list
  static final List<String> denyList = [''];

  bool isValidPackageName(String id) {
    return _lowerCaseUnderScoreWithLeadingUnderscores.hasMatch(id) &&
        isValidDartIdentifier(id);
  }

  bool isSafe(String project_name) {
    /// Check `project_name` against Dart identifiers & keywords
    if (!isValidPackageName(project_name)) {
      return false;
    }

    /// Check project name against PB's `denyList`
    if (denyList.any((element) => element == project_name)) {
      return false;
    }
    return true;
  }
}
