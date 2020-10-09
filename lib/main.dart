import 'dart:convert';
import 'dart:io';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/controllers/sketch_controller.dart';
import 'package:parabeac_core/input/sketch/services/input_design.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_plugin_list_helper.dart';
import 'package:quick_log/quick_log.dart';
import 'package:sentry/sentry.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:args/args.dart';

import 'controllers/main_info.dart';

String resultsDirectory = Platform.environment['SENTRY_DSN'] ?? '/temp';
final SentryClient sentry = SentryClient(dsn: resultsDirectory);
ArgResults argResults;

void main(List<String> args) async {
  await checkConfigFile();

  //Sentry logging initialization
  MainInfo().sentry = SentryClient(dsn: resultsDirectory);
  var log = Logger('Main');
  log.info(args.toString());

  MainInfo().cwd = Directory.current;

  ///sets up parser
  final parser = ArgParser()
    ..addOption('path',
        help: 'Path to the design file', valueHelp: 'path', abbr: 'p')
    ..addOption('out', help: 'The output path', valueHelp: 'path', abbr: 'o')
    ..addOption('project-name',
        help: 'The name of the project', abbr: 'n', defaultsTo: 'temp')
    ..addOption('config-path',
        help: 'Path of the configuration file',
        abbr: 'c',
        defaultsTo: 'default:lib/configurations/configurations.json')
    ..addFlag('help',
        help: 'Displays this help information.', abbr: 'h', negatable: false);

//error handler using logger package
  void handleError(String msg) {
    log.error(msg);
    exitCode = 2;
    exit(2);
  }

  argResults = parser.parse(args);

  //Check if no args passed or only -h/--help passed
  if (argResults['help'] || argResults.arguments.isEmpty) {
    print('''
  ** PARABEAC HELP **
${parser.usage}
    ''');
    exit(0);
  }

  String path = argResults['path'];
  var designType = 'sketch';
  var configurationPath = argResults['config-path'];
  var configurationType = 'default';
  String projectName = argResults['project-name'];

  if (path == null) {
    handleError('Missing required argument: path');
  }
  var file = await FileSystemEntity.isFile(path);
  var exists = await File(path).exists();

  if (!file || !exists) {
    handleError('$path is not a file');
  }

  if (path.endsWith('.sketch')) {
    designType = 'sketch';
  } else if (path.endsWith('.fig')) {
    designType = 'figma';
  }

  //  usage -c "default:lib/configurations/configurations.json
  var configSet = configurationPath.split(':');
  if (configSet.isNotEmpty) {
    configurationType = configSet[0];
  }
  if (configSet.length >= 2) {
    // handle configurations
    configurationPath = configSet[1];
  }

  // Populate `MainInfo()`
  MainInfo().outputPath = argResults['out'];
  // If outputPath is empty, assume we are outputting to design file path path
  MainInfo().outputPath ??= getCleanPath(path);
  if (!MainInfo().outputPath.endsWith('/')) {
    MainInfo().outputPath += '/';
  }
  MainInfo().sketchPath = path;
  MainInfo().projectName = projectName;

  // Input
  var id = InputDesignService(path);

  if (designType == 'sketch') {
    var process = await Process.start('npm', ['run', 'prod'],
        workingDirectory: MainInfo().cwd.path + '/SketchAssetConverter');

    await for (var event in process.stdout.transform(utf8.decoder)) {
      if (event.toLowerCase().contains('server is listening on port')) {
        log.fine('Successfully started Sketch Asset Converter');
        break;
      }
    }

    //Retrieving the Sketch PNGs from the design file
    await Directory('${MainInfo().outputPath}pngs').create(recursive: true);
    await SketchController().convertSketchFile(
        path,
        MainInfo().outputPath + projectName,
        configurationPath,
        configurationType);
    process.kill();
  } else if (designType == 'xd') {
    assert(false, 'We don\'t support Adobe XD.');
  } else if (designType == 'figma') {
    assert(false, 'We don\'t support Figma.');
  }
  exitCode = 0;
}

/// Checks whether a configuration file is made already,
/// and makes one if necessary
Future<void> checkConfigFile() async {
  var envvars = Platform.environment;

  // Do not get metrics if user has envvar PB_METRICS set to false
  if (envvars['PB_METRICS'] != null &&
      envvars['PB_METRICS'].toLowerCase().contains('false')) {
    return;
  }

  var homepath = getHomePath();
  var configFile = File('$homepath/.config/.parabeac/config.json');
  if (!(await configFile.exists())) {
    createConfigFile(configFile);
  } else {
    var configMap = jsonDecode(configFile.readAsStringSync());
    MainInfo().deviceId = configMap['device_id'];
  }

  await addToAmplitude();
}

/// Gets the homepath of the user according to their OS
String getHomePath() {
  var envvars = Platform.environment;

  if (Platform.isWindows) {
    return envvars['UserProfile'];
  }
  return envvars['HOME'];
}

/// Creates and populates parabeac config file
void createConfigFile(File configFile) {
  configFile.createSync(recursive: true);
  var configMap = {'device_id': Uuid().v4()};
  configFile.writeAsStringSync(jsonEncode(configMap));
  MainInfo().deviceId = configMap['device_id'];
}

/// Adds current run to amplitude metrics
void addToAmplitude() async {
  var lambdaEndpt =
      'https://jsr2rwrw5m.execute-api.us-east-1.amazonaws.com/default/pb-lambda-microservice';

  var body = json.encode({
    'id': MainInfo().deviceId,
    'eventProperties': {'eggs': PBPluginListHelper.names ?? {}}
  });

  await http.post(
    lambdaEndpt,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: body,
  );
}

String getCleanPath(String path) {
  var list = path.split('/');
  var result = '';
  for (var i = 0; i < list.length - 1; i++) {
    result += list[i] + '/';
  }
  return result;
}
