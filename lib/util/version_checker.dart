import 'dart:convert';

import 'package:parabeac_core/util/pubspec_utils.dart';
import 'package:pbdl/pbdl.dart';
import 'package:quick_log/quick_log.dart';
import 'package:http/http.dart' as http;

var _logger = Logger('VersionChecker');

/// Function that checks if both parabeac_core and PBDL are up to date.
Future<void> checkAllVersions() async {
  await checkPbcVersions();
  await checkPbdlVersions();
}

/// Function that checks whether the local version of
/// parabeac_core matches the latest version.
Future<void> checkPbcVersions() async {
  /// Check local parabeac_core version.
  var localVersion = PubspecUtils('pubspec.yaml').getPackageVersion();
  var latestVersion = await _getVersionFromGithubUrl(
      'https://api.github.com/repos/parabeac/parabeac_core/tags');

  _logger.info('Local parabeac_core version: $localVersion');
  _logger.info('Latest remote parabeac_core version: $latestVersion');
  if (latestVersion.isEmpty) {
    _logger.error('Could not fetch latest parabeac_core version from github.');
  } else if (latestVersion == localVersion) {
    _logger.fine('Local parabeac_core version is up to date.');
  } else {
    _logger.warning(
        'Local parabeac_core version is out of date. Please update via `git pull` or download the latest release.');
  }
}

/// Function that checks whether the local version of
/// PBDL matches the latest version.
Future<void> checkPbdlVersions() async {
  var localVersion = PBDL.version();
  var gitPbdlVersion = await _getVersionFromGithubUrl(
      'https://api.github.com/repos/parabeac/pbdl/tags');

  _logger.info('Local parabeac_core version: $localVersion');
  _logger.info('Latest remote parabeac_core version: $gitPbdlVersion');
  if (gitPbdlVersion.isEmpty) {
    _logger.error('Could not fetch latest PBDL version from github.');
  } else if (localVersion == gitPbdlVersion) {
    _logger.fine('Local PBDL version is up to date.');
  } else {
    _logger.warning(
        'Local PBDL version is out of date. Please update via `dart pub upgrade`');
  }
}

/// Function that gets the latest `tag` from the `url`.
///
/// Assumes that the `url` is a Github repo with the form: `https://api.github.com/repos/{owner}/{repo}/tags`.
Future<String> _getVersionFromGithubUrl(String url) async {
  /// Check latest parabeac_core version.
  var remoteResponse = await http.get(
    Uri.parse(url),
  );

  if (remoteResponse.statusCode == 200) {
    var responseJson = jsonDecode(remoteResponse.body);

    /// Version is in the form of 'vM.m.p' so we need to remove the "v"
    return responseJson[0]['name'].toString().replaceFirst('v', '');
  } else {
    return '';
  }
}
