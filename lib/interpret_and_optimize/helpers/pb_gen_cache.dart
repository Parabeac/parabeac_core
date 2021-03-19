import 'dart:math';

/// Class that caches generated classes
class PBGenCache {
  PBGenCache._internal();

  static final PBGenCache _instance = PBGenCache._internal();

  factory PBGenCache() => _instance;

  /// Cache where the key is the doObjectId and the value is the paths associated
  /// to the doObjectId
  Map<String, Set<String>> _cache = {};

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
      // Tokenize [filePath] and the path to the file of [doObjectId]
      List<String> filePathTokens = filePath.split('/')
        ..removeLast()
        ..removeAt(0);
      if (targetPath == filePath) {
        continue;
      }
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
        paths.add('./$targetFileName');
      }
      // Case for when backtracking is not needed to get to [targetPath]
      else if (filePathTokens.isEmpty) {
        String result = './';
        for (String folder in targetPathTokens) {
          result = '$result$folder/';
        }
        paths.add('$result$targetFileName');
      }
      // Case for when backtracking is needed to get to [targetPath]
      else {
        String result = '';

        // Backtrack
        for (int i = 0; i < filePathTokens.length; i++) {
          result = '$result../';
        }

        // Add necessary folders
        for (int i = 0; i < targetPathTokens.length; i++) {
          result = '$result${targetPathTokens[i]}/';
        }
        paths.add('$result$targetFileName');
      }
    }
    return paths;
  }
}
