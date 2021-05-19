import 'dart:math';

/// Class that caches generated classes
class PBGenCache {
  PBGenCache._internal();

  static final PBGenCache _instance = PBGenCache._internal();

  factory PBGenCache() => _instance;

  /// Cache where the key is the doObjectId and the value is the paths associated
  /// to the doObjectId
  final Map<String, Set<String>> _cache = {};

  /// Associates `path` to `doObjectId` in this cache.
  void setPathToCache(String doObjectId, String path) {
    _cache[doObjectId] = {path};
  }

  /// Appends a `path` to `doObjectId` in the cache.
  void appendToCache(String doObjectId, String path) {
    if (!_cache.containsKey(doObjectId)) {
      setPathToCache(doObjectId, path);
    } else {
      _cache[doObjectId].add(path);
    }
  }

  void removeFromCache(String doObjectId) {
    _cache.remove(doObjectId);
  }

  ///  Returns the path of the cache at key [doObjectId]
  Set<String> getPaths(String doObjectId) => _cache[doObjectId] ?? {};

  /// Returns the relative paths to get from [filePath] to the path of [doObjectId].
  /// Note: [filePath] must be an absolute path
  Set<String> getRelativePath(String filePath, String doObjectId) {
    var targetPaths = _cache[doObjectId];
    var paths = <String>{};
    if (targetPaths == null || targetPaths.isEmpty) {
      return null;
    }

    for (var targetPath in targetPaths) {
      if (targetPath == filePath) {
        continue;
      }
      paths.add(getRelativePathFromPaths(filePath, targetPath));
    }
    return paths;
  }

  String getRelativePathFromPaths(String filePath, String targetPath) {
    // Tokenize [filePath] and the path to the file of [doObjectId]
    var filePathTokens = filePath.split('/')
      ..removeLast()
      ..removeAt(0);

    var targetPathTokens = targetPath.split('/')..removeAt(0);
    var targetFileName = targetPathTokens.removeLast();
    // Get rid of paths that are the same
    while (min(filePathTokens.length, targetPathTokens.length) != 0 &&
        filePathTokens[0] == targetPathTokens[0]) {
      filePathTokens.removeAt(0);
      targetPathTokens.removeAt(0);
    }

    // Case for when files are in the same folder
    if (filePathTokens.isEmpty && targetPathTokens.isEmpty) {
      return './$targetFileName';
    }
    // Case for when backtracking is not needed to get to [targetPath]
    else if (filePathTokens.isEmpty) {
      var result = './';
      for (var folder in targetPathTokens) {
        result = '$result$folder/';
      }
      return '$result$targetFileName';
    }
    // Case for when backtracking is needed to get to [targetPath]
    else {
      var result = '';

      // Backtrack
      for (var i = 0; i < filePathTokens.length; i++) {
        result = '$result../';
      }

      // Add necessary folders
      for (var i = 0; i < targetPathTokens.length; i++) {
        result = '$result${targetPathTokens[i]}/';
      }
      return '$result$targetFileName';
    }
  }
}
