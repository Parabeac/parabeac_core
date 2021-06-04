import 'dart:math';

import 'package:path/path.dart' as p;

class FlutterImport {
  /// Where the source code starts.
  static final String srcPathDelimiter = 'lib';

  /// The [path] is the relative or absolue [path] of where the import is
  /// pointing to.
  ///
  /// For example, one of the imports for this file is `import 'package:path/path.dart' as p;`,
  /// the path would be `/path.dart`. Or in the case that is relative, it would be the entire
  /// content of the import.
  final String path;

  /// The [package] is the actual package where the [FlutterImport] comes from.
  ///
  /// For example `import 'package:path/path.dart' as p;`, the package would be `path`,
  /// without include the `package:` or `path.dart` section. Relative [path] are going
  /// to contain this field `null`
  final String package;

  FlutterImport(this.path, [this.package]);

  /// Adds the extra syntax that comes when generating an import.
  ///
  /// if [isPackage] is `true`, is going to include the extra syntax for
  /// packages. If the [content] was not provided, then its going to return an
  /// empty string.
  static String importFormat(String content,
      {bool isPackage = false, bool newLine = true}) {
    if (content != null) {
      return 'import \'${isPackage ? 'package:' : ''}$content\';${newLine ? '\n' : ''}';
    }
    return '';
  }

  /// Formats the [absPath] to eliminate the path that are not within the project,
  /// this is to format it in the following manner: `package:`+[packageName]+`path`
  static String absImportFormat(
    String packageName,
    String absPath,
  ) {
    if (absPath.contains(packageName)) {
      var components = p.split(absPath);

      /// We are going to cut off the furthest into the [absPath]
      ///
      /// either into the [packageName] or where the source code is, the [srcPathDelimiter]
      var delimiter = max(components.indexOf(srcPathDelimiter),
          components.indexOf(packageName));
      if (delimiter < 0) {
        return '';
      }
      return importFormat(
          p.join(packageName,
              p.joinAll(components.getRange(++delimiter, components.length))),
          isPackage: true);
    }
    return importFormat(absPath);
  }

  @override
  String toString() {
    return package == null
        ? importFormat(path)
        : absImportFormat(package, p.join(package, path));
  }

  @override
  int get hashCode => path.hashCode;

  @override
  bool operator ==(Object import) {
    if (import is FlutterImport) {
      return import.hashCode == hashCode;
    }
    return false;
  }
}
