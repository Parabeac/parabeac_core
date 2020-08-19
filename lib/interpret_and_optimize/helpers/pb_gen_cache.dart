import 'dart:math';

/// Class that caches generated classes
class PBGenCache {
  PBGenCache._internal();

  static final PBGenCache _instance = PBGenCache._internal();

  factory PBGenCache() => _instance;

  //Cache where the key is the doObjectId and the value is the path
  Map<String, String> _cache = {};

  void addToCache(String doObjectId, String path) {
    _cache[doObjectId] = path;
  }

  void removeFromCache(String doObjectId) {
    _cache.remove(doObjectId);
  }

  ///  Returns the path of the cache at key [doObjectId]
  String getPath(String doObjectId) => _cache[doObjectId];

  /// Returns the relative path to get from [filePath] to the path of [doObjectId].
  /// Note: [filePath] must be an absolute path
  String getRelativePath(String filePath, String doObjectId) {
    String targetPath = _cache[doObjectId];
    if (targetPath == null || targetPath.isEmpty) {
      return null;
    }
    if (filePath == targetPath) {
      return '';
    }

    // Tokenize [filePath] and the path to the file of [doObjectId]
    List<String> filePathTokens = filePath.split('/')
      ..removeLast()
      ..removeAt(0);
    List<String> targetPathTokens = targetPath.split('/')..removeAt(0);
    String targetFileName = targetPathTokens.removeLast();

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
      String result = './';
      for (String folder in targetPathTokens) {
        result = '$result$folder/';
      }
      return '$result$targetFileName';
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

      return '$result$targetFileName';
    }
  }
}
