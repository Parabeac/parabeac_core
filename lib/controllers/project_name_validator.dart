import 'package:linter/src/utils.dart' as linter_utils;

/// This class verifies that the provided project name is in line with the Dart
/// Pubspec [format](https://dart.dev/tools/pub/pubspec#name)
/// using the official linter package from Dart.
///
/// The purpose of this class is to validate project names ahead of `flutter create`
/// in order properly handle errors.
///
class ProjectNameValidator {
  static final List<String> denyList = [''];

  static bool isSafe(String project_name) {
    /// Check `project_name` against Dart rules
    if (!linter_utils.isValidPackageName(project_name)) {
      return false;
    }

    /// Check project name against PB `denyList`
    if (denyList.any((element) => element == project_name)) {
      return false;
    }

    return true;
  }
}
