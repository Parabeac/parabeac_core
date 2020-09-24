import 'dart:convert';
import 'dart:io';
import 'package:parabeac_core/APICaller/api_call_service.dart';
import 'package:parabeac_core/controllers/figma_controller.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/controllers/sketch_controller.dart';
import 'package:parabeac_core/input/sketch/services/input_design.dart';
import 'package:quick_log/quick_log.dart';
import 'package:sentry/sentry.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'controllers/main_info.dart';

String pathToSketchFile;
String resultsDirectory = Platform.environment['SENTRY_DSN'] ?? '/temp';
final SentryClient sentry = SentryClient(dsn: resultsDirectory);

void main(List<String> args) async {
  await checkConfigFile();

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
        MainInfo().sketchPath = pathToSketchFile;
        // If outputPath is empty, assume we are outputting to sketch path
        MainInfo().outputPath ??= getCleanPath(path);
        if (pathToSketchFile.endsWith('.sketch')) {
          designType = 'sketch';
        } else if (pathToSketchFile.endsWith('.fig')) {
          designType = 'figma';
        }
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
      case '-fig':
        designType = 'figma';
        MainInfo().figmaProjectID = args[i + 1];
        break;
      case '-figKey':
        MainInfo().figmaKey = args[i + 1];
        break;
    }
  }

  if (!MainInfo().outputPath.endsWith('/')) {
    MainInfo().outputPath += '/';
  }

  if (projectName.isEmpty) {
    projectName = 'temp';
  }

  MainInfo().projectName = projectName;

  // Input
  if (path != null && path.isNotEmpty) {
    var id = InputDesignService(path);
  }

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
    await SketchController().convertFile(pathToSketchFile,
        MainInfo().outputPath + projectName, configurationPath);
    process.kill();
  } else if (designType == 'xd') {
    assert(false, 'We don\'t support Adobe XD.');
  } else if (designType == 'figma') {
    if (MainInfo().figmaKey == null || MainInfo().figmaKey.isEmpty) {
      assert(false, 'Please provided a Figma API key to proceed.');
    }
    if (MainInfo().figmaProjectID == null ||
        MainInfo().figmaProjectID.isEmpty) {
      assert(false, 'Please provided a Figma project ID to proceed.');
    }
    var figma = APICallService();
    var jsonOfFigma = await figma.makeAPICall([
      'https://api.figma.com/v1/files/${MainInfo().figmaProjectID}',
      MainInfo().figmaKey
    ]);
    if (jsonOfFigma != null) {
      // Starts Figma to Object
      FigmaController().convertFile(
          jsonOfFigma, MainInfo().outputPath + projectName, configurationPath);
    } else {
      log.error('File was not retrieve it from Figma.');
    }
  }
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

  var body = json.encode({'id': MainInfo().deviceId});

  await http.post(
    lambdaEndpt,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: body,
  );
}

String getCleanPath(String path) {
  var list = path.split('/');
  var result = '';
  for (int i = 0; i < list.length - 1; i++) {
    result += list[i] + '/';
  }
  return result;
}
