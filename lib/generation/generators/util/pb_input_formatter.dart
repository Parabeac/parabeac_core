import 'package:recase/recase.dart';

class PBInputFormatter {
  ///Formats input to destroy spaces and other intrusive characters.
  ///
  ///Returns an upper-camelcase string if `isTitle` is true,
  ///or a lowercase string otherwise.
  static String formatLabel(String input,
      {bool isTitle = false,
      bool spaceToUnderscore = true,
      bool destroyDigits = false,
      bool destroySpecialSym = false}) {
    assert(input != null);
    var result = _formatStr(input,
        spaceToUnderscore: spaceToUnderscore, destroyDigits: destroyDigits);

    (isTitle) ? result = result.pascalCase : result = result.toLowerCase();
    return result;
  }

  /// Removes all non alphabet characters at the beggining of the string, and remove spaces
  static String formatPageName(String input) {
    return input.replaceAll(RegExp(r'^[^a-zA-Z]*'), '').replaceAll(' ', '');
  }

  ///Formats `input` to destroy spaces and other intrusive characters.
  ///
  ///Returns a camelCase string.
  static String formatVariable(String input) => _formatStr(input).camelCase;

  static String _formatStr(
    String input, {
    bool spaceToUnderscore = true,
    bool destroyDigits = false,
  }) {
    var result = input;
    // TODO: set a temporal name
    result = (result.isEmpty) ? 'tempName' : result;

    result = result.trim();
    var spaceChar = (spaceToUnderscore) ? '_' : '';
    result = result.replaceAll(r'[\s\./_+?]+', spaceChar);
    result = result.replaceAll(RegExp(r'\s+'), spaceChar);
    result = result.replaceAll(' ', '').replaceAll(RegExp(r'[^\s\w]'), '');
    result = removeFirstDigits(result);
    result = (destroyDigits) ? result.replaceAll(RegExp(r'\d+'), '') : result;
    return result;
  }

  static String removeFirstDigits(String str) =>
      str.startsWith(RegExp(r'^[\d]+'))
          ? str.replaceFirstMapped(RegExp(r'^[\d]+'), (e) => '')
          : str;

  /// Method that splits `target` according to `delimeter`
  /// and returns the last entry in the list.
  static String findLastOf(String target, String delimeter) {
    if (target == null || delimeter == null) {
      return '';
    }
    return target.split(delimeter).last;
  }
}
