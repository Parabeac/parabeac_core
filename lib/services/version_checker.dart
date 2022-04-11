import 'dart:convert';

import 'package:parabeac_core/services/pubspec_service.dart';
import 'package:quick_log/quick_log.dart';
import 'package:http/http.dart' as http;

var _logger = Logger('VersionChecker');

/// Function that checks whether the local version of
/// parabeac_core matches the latest version.
Future<void> checkVersions() async {
  /// Check local parabeac_core version.
  var localVersion = PubspecService('pubspec.yaml').getPackageVersion();
  _logger.info('Local parabeac_core version: $localVersion');

  /// Check latest parabeac_core version.
  var remoteResponse = await http.get(
    Uri.parse(
      'https://api.github.com/repos/parabeac/parabeac_core/tags',
    ),
  );

  if (remoteResponse.statusCode == 200) {
    var responseJson = jsonDecode(remoteResponse.body);

    /// Version is in the form of 'vM.m.p' so we need to remove the "v"
    var latestVersion =
        responseJson[0]['name'].toString().replaceFirst('v', '');
    _logger.info('Latest remote parabeac_core version: $latestVersion');
    if (latestVersion == localVersion) {
      _logger.info('Local version is up to date.');
    } else {
      _logger.warning('Local parabeac_core version is out of date. Please update via `git pull` or download the latest release.');
    }
  } else {
    _logger.info('Could not fetch remote version.');
  }
}
