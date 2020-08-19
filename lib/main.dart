import 'dart:io';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/controllers/sketch_controller.dart';
import 'package:parabeac_core/input/services/input_design.dart';
import 'package:quick_log/quick_log.dart';
import 'package:sentry/sentry.dart';

import 'controllers/main_info.dart';

String pathToSketchFile;
String resultsDirectory = Platform.environment['SENTRY_DSN'] ?? '/temp';
final SentryClient sentry = SentryClient(dsn: resultsDirectory);

void main(List<String> args) async {
  MainInfo().sentry = SentryClient(dsn: resultsDirectory);
  var log = Logger('Main');

  log.info(args.toString());

  MainInfo().cwd = Directory.current;

  var path = '';
  var projectName = '';
  var designType = 'sketch';
  var configurationPath;
  for (var i = 0; i < args.length; i += 2) {
    switch (args[i]) {
      case '-p':
        path = args[i + 1];
        pathToSketchFile = path;
        // If outputPath is empty, assume we are outputting to sketch path
        MainInfo().outputPath ??= getCleanPath(path);
        break;
      case '-o':
        MainInfo().outputPath = args[i + 1];

        break;
      case '-n':
        projectName = args[i + 1];
        break;
      case '-c':
        // handle configurations
        configurationPath = 'lib/configurations/configurations.json';
        break;
    }
  }

  if (!MainInfo().outputPath.endsWith('/')) {
    MainInfo().outputPath += '/';
    print('Forgot a slash bucko, ${MainInfo().outputPath}');
  }

  if (projectName.isEmpty) {
    projectName = 'temp';
  }

  // Input
  var id = InputDesignService(path);

  if (designType == 'sketch') {
    //Retrieving the Sketch PNGs from the design file
    await Directory('${MainInfo().outputPath}pngs').create(recursive: true);
    // ignore: unawaited_futures
    // await Process.run('sh', [
    //   '${MainInfo().homepath}pb-scripts/sketchtool_proxy.sh ${pathToSketchFile} export slices --output=${MainInfo().homepath}pngs/ --overwriting YES --item name'
    // ]).then((value) {
    //   log.info(value.stdout);
    //   log.error(value.stderr);
    // });
    await SketchController().convertSketchFile(pathToSketchFile,
        MainInfo().outputPath + projectName, configurationPath);
  } else if (designType == 'xd') {
    assert(false, 'We don\'t support Adobe XD.');
  } else if (designType == 'figma') {
    assert(false, 'We don\'t support Figma.');
  }
}

String getCleanPath(String path) {
  var list = path.split('/');
  var result = '';
  for (int i = 0; i < list.length - 1; i++) {
    result += list[i] + '/';
  }
  return result;
}
