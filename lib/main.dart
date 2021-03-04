import 'dart:convert';
import 'dart:io';
import 'package:parabeac_core/controllers/design_controller.dart';
import 'package:parabeac_core/controllers/figma_controller.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/controllers/sketch_controller.dart';
import 'package:parabeac_core/input/figma/helper/api_call_service.dart';
import 'package:parabeac_core/input/figma/helper/figma_asset_processor.dart';
import 'package:parabeac_core/input/helper/azure_asset_service.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_asset_processor.dart';
import 'package:parabeac_core/input/sketch/services/input_design.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_plugin_list_helper.dart';
import 'package:quick_log/quick_log.dart';
import 'package:sentry/sentry.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:args/args.dart';
import 'controllers/main_info.dart';
import 'package:yaml/yaml.dart';

ArgResults argResults;

void main(List<String> args) async {
  await checkConfigFile();

  //Sentry logging initialization
  MainInfo().sentry = SentryClient(
      dsn:
          'https://6e011ce0d8cd4b7fb0ff284a23c5cb37@o433482.ingest.sentry.io/5388747');
  var log = Logger('Main');
  var pubspec = File('pubspec.yaml');
  await pubspec.readAsString().then((String text) {
    Map yaml = loadYaml(text);
    log.info('Current version: ${yaml['version']}');
  });
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
    ..addOption('fig', help: 'The ID of the figma file', abbr: 'f')
    ..addOption('figKey', help: 'Your personal API Key', abbr: 'k')
    ..addOption(
      'pbdl-in',
      help:
          'Takes in a Parabeac Design Logic (PBDL) JSON file and exports it to a project',
    )
    ..addFlag('help',
        help: 'Displays this help information.', abbr: 'h', negatable: false)
    ..addFlag('export-pbdl',
        help: 'This flag outputs Parabeac Design Logic (PBDL) in JSON format.');

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

  // Detect platform
  if (Platform.isMacOS || Platform.isLinux) {
    MainInfo().platform = 'UIX';
  } else if (Platform.isWindows) {
    MainInfo().platform = 'WIN';
  } else {
    MainInfo().platform = 'OTH';
  }

  String path = argResults['path'];

  MainInfo().figmaKey = argResults['figKey'];
  MainInfo().figmaProjectID = argResults['fig'];

  var designType = 'sketch';
  var jsonOnly = argResults['export-pbdl'];

  var configurationPath = argResults['config-path'];
  var configurationType = 'default';
  String projectName = argResults['project-name'];

  // Handle input errors
  if (hasTooFewArgs(argResults)) {
    handleError(
        'Missing required argument: path to Sketch file or both Figma Key and Project ID.');
  } else if (hasTooManyArgs(argResults)) {
    handleError(
        'Too many arguments: Please provide either the path to Sketch file or the Figma File ID and API Key');
  } else if (argResults['figKey'] != null && argResults['fig'] != null) {
    designType = 'figma';
  } else if (argResults['pbdl-in'] != null) {
    designType = 'pbdl';
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
  // If outputPath is empty, assume we are outputting to design file path
  MainInfo().outputPath ??= await getCleanPath(path ?? Directory.current.path);
  if (!MainInfo().outputPath.endsWith('/')) {
    MainInfo().outputPath += '/';
  }

  MainInfo().projectName = projectName;

  // Create pngs directory

  await Directory('${MainInfo().outputPath}' +
          (jsonOnly || argResults['pbdl-in'] != null ? '' : 'pngs'))
      .create(recursive: true);

  if (designType == 'sketch') {
    Process process;
    if (!jsonOnly) {
      var file = await FileSystemEntity.isFile(path);
      var exists = await File(path).exists();

      if (!file || !exists) {
        handleError('$path is not a file');
      }
      MainInfo().sketchPath = path;
      InputDesignService(path);

      if (!Platform.environment.containsKey('SAC_ENDPOINT')) {
        var isSACupToDate = await Process.run(
          './lib/generation/helperScripts/check-git.sh',
          [],
          workingDirectory: MainInfo().cwd.path,
        );

        if (isSACupToDate.stdout
            .contains('Sketch Asset Converter is up to date!')) {
          log.info(isSACupToDate.stdout);
        } else {
          log.warning(isSACupToDate.stdout);
        }

        process = await Process.start('npm', ['run', 'prod'],
            workingDirectory: MainInfo().cwd.path + '/SketchAssetConverter');

        await for (var event in process.stdout.transform(utf8.decoder)) {
          if (event.toLowerCase().contains('server is listening on port')) {
            log.fine('Successfully started Sketch Asset Converter');
            break;
          }
        }
      }
    }

    SketchController().convertFile(
      path,
      MainInfo().outputPath + projectName,
      configurationPath,
      configurationType,
      jsonOnly: jsonOnly,
      apService: SketchAssetProcessor(),
    );
    process?.kill();
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
    var jsonOfFigma = await APICallService.makeAPICall(
        'https://api.figma.com/v1/files/${MainInfo().figmaProjectID}',
        MainInfo().figmaKey);

    if (jsonOfFigma != null) {
      AzureAssetService().projectUUID = MainInfo().figmaProjectID;
      // Starts Figma to Object
      FigmaController().convertFile(
        jsonOfFigma,
        MainInfo().outputPath + projectName,
        configurationPath,
        configurationType,
        jsonOnly: jsonOnly,
        apService: FigmaAssetProcessor(),
      );
    } else {
      log.error('File was not retrieved from Figma.');
    }
  } else if (designType == 'pbdl') {
    var pbdlPath = argResults['pbdl-in'];
    var isFile = FileSystemEntity.isFileSync(pbdlPath);
    var exists = File(pbdlPath).existsSync();

    if (!isFile || !exists) {
      handleError('$path is not a file');
    }

    var jsonString = await File(pbdlPath).readAsString();

    var pbdf = json.decode(jsonString);

    DesignController().convertFile(
      pbdf,
      MainInfo().outputPath + projectName,
      configurationPath,
      configurationType,
    );
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

Future<String> getCleanPath(String path) async {
  if (path == null || path.isEmpty) {
    return '';
  }
  var list = path.split('/');
  if (!await Directory(path).exists()) {
    list.removeLast();
  }
  var result = '';
  for (var dir in list) {
    result += dir + '/';
  }
  return result;
}

/// Returns true if `args` contains two or more
/// types of intake to parabeac-core
bool hasTooManyArgs(ArgResults args) {
  var hasSketch = args['path'] != null;
  var hasFigma = args['figKey'] != null || args['fig'] != null;
  var hasPbdl = args['pbdl-in'] != null;

  var hasAll = hasSketch && hasFigma && hasPbdl;

  return hasAll || !(hasSketch ^ hasFigma ^ hasPbdl);
}

/// Returns true if `args` does not contain any intake
/// to parabeac-core
bool hasTooFewArgs(ArgResults args) {
  var hasSketch = args['path'] != null;
  var hasFigma = args['figKey'] != null && args['fig'] != null;
  var hasPbdl = args['pbdl-in'] != null;

  return !(hasSketch || hasFigma || hasPbdl);
}
