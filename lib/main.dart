import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/isolation_post_gen_task.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/flutter_project_builder/file_system_analyzer.dart';
import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/component_isolation_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_plugin_list_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/services/design_to_pbdl/design_to_pbdl_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/design_to_pbdl/figma_to_pbdl_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/design_to_pbdl/json_to_pbdl_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/design_to_pbdl/sketch_to_pbdl_service.dart';
import 'package:quick_log/quick_log.dart';
import 'package:sentry/sentry.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:args/args.dart';
import 'controllers/interpret.dart';
import 'controllers/main_info.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

import 'interpret_and_optimize/entities/pb_shared_instance.dart';
import 'interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

final designToPBDLServices = <DesignToPBDLService>[
  JsonToPBDLService(),
  SketchToPBDLService(),
  FigmaToPBDLService(),
];
FileSystemAnalyzer fileSystemAnalyzer;
Interpret interpretService = Interpret();

///sets up parser
final parser = ArgParser()
  ..addOption('path',
      help: 'Path to the design file', valueHelp: 'path', abbr: 'p')
  ..addOption('out', help: 'The output path', valueHelp: 'path', abbr: 'o')
  ..addOption('project-name',
      help: 'The name of the project', abbr: 'n', defaultsTo: 'foo')
  ..addOption('config-path',
      help: 'Path of the configuration file',
      abbr: 'c',
      defaultsTo:
          '${p.setExtension(p.join('lib/configurations/', 'configurations'), '.json')}')
  ..addOption('fig', help: 'The ID of the figma file', abbr: 'f')
  ..addOption('figKey', help: 'Your personal API Key', abbr: 'k')
  ..addOption(
    'pbdl-in',
    help:
        'Takes in a Parabeac Design Logic (PBDL) JSON file and exports it to a project',
  )
  ..addOption('oauth', help: 'Figma OAuth Token')
  ..addFlag('help',
      help: 'Displays this help information.', abbr: 'h', negatable: false)
  ..addFlag('export-pbdl',
      help: 'This flag outputs Parabeac Design Logic (PBDL) in JSON format.')
  ..addFlag('exclude-styles',
      help: 'If this flag is set, it will exclude output styles document');

Future<void> main(List<String> args) async {
  await runZonedGuarded(() async {
    await Sentry.init(
      (p0) => p0.dsn =
          'https://6e011ce0d8cd4b7fb0ff284a23c5cb37@o433482.ingest.sentry.io/5388747',
    );
    await runParabeac(args);
  }, (error, stackTrace) async {
    await Sentry.captureException(error);
    await Sentry.close();
  });
  await Sentry.close();
}

Future<void> runParabeac(List<String> args) async {
  await checkConfigFile();
  var log = Logger('Main');
  var pubspec = File('pubspec.yaml');
  await pubspec.readAsString().then((String text) {
    Map yaml = loadYaml(text);
    log.info('Current version: ${yaml['version']}');
  });
  log.info(args.toString());

  MainInfo().cwd = Directory.current;

  //error handler using logger package
  void handleError(String msg) {
    log.error(msg);
    exitCode = 2;
    exit(2);
  }

  var argResults = parser.parse(args);

  /// Check if no args passed or only -h/--help passed
  if (argResults['help'] || argResults.arguments.isEmpty) {
    print('''
  ** PARABEAC HELP **
${parser.usage}
    ''');
    exit(0);
  } else if (hasTooFewArgs(argResults)) {
    handleError(
        'Missing required argument: path to Sketch file or both Figma Key and Project ID.');
  } else if (hasTooManyArgs(argResults)) {
    handleError(
        'Too many arguments: Please provide either the path to Sketch file or the Figma File ID and API Key');
  }

  collectArguments(argResults);

  var processInfo = MainInfo();
  if (processInfo.designType == DesignType.UNKNOWN) {
    throw UnsupportedError('We have yet to support this DesignType! ');
  }

  Future indexFileFuture;
  fileSystemAnalyzer = FileSystemAnalyzer(processInfo.genProjectPath);
  fileSystemAnalyzer.addFileExtension('.dart');

  if (!(await fileSystemAnalyzer.projectExist())) {
    await FlutterProjectBuilder.createFlutterProject(processInfo.projectName,
        projectDir: processInfo.outputPath);
  } else {
    indexFileFuture = fileSystemAnalyzer.indexProjectFiles();
  }

  var pbdlService = designToPBDLServices.firstWhere(
    (service) => service.designType == processInfo.designType,
  );
  var pbdl = await pbdlService.callPBDL(processInfo);
  // Exit if only generating PBDL
  if (MainInfo().exportPBDL) {
    exitCode = 0;
    return;
  }
  var pbProject = PBProject.fromJson(pbdl.toJson());
  pbProject.projectAbsPath =
      p.join(processInfo.outputPath, processInfo.projectName);

  /// Scan the forest to detect any MasterNode inside a tree
  /// if that's the case, extract that Master
  /// add it to the forest and replace it with an instance

  var tempForest = <PBIntermediateTree>[];

  for (var tree in pbProject.forest) {
    var manyTrees = await treeHasMaster(tree);

    tree = manyTrees.removeAt(0);

    if (manyTrees.isNotEmpty) {
      tempForest.addAll(manyTrees);
    }
  }

  pbProject.forest.addAll(tempForest);

  var fpb = FlutterProjectBuilder(
      MainInfo().configuration.generationConfiguration, fileSystemAnalyzer,
      project: pbProject);

  await fpb.preGenTasks();

  /// Get ComponentIsolationService (if any), and add it to the list of services
  var isolationConfiguration = ComponentIsolationConfiguration.getConfiguration(
    MainInfo().configuration.componentIsolation,
    pbProject.genProjectData,
  );
  if (isolationConfiguration != null) {
    interpretService.aitHandlers.add(isolationConfiguration.service);
    fpb.postGenTasks.add(IsolationPostGenTask(
        isolationConfiguration.generator, fpb.generationConfiguration));
  }
  await indexFileFuture;

  var trees = <PBIntermediateTree>[];

  for (var tree in pbProject.forest) {
    var context = PBContext(processInfo.configuration);
    context.project = pbProject;

    /// Assuming that the [tree.rootNode] has the dimensions of the screen.
    context.screenFrame = Rectangle3D.fromPoints(
        tree.rootNode.frame.topLeft, tree.rootNode.frame.bottomRight);

    context.tree = tree;
    tree.context = context;

    tree.forEach((child) => child.handleChildren(context));

    var candidateTree =
        await interpretService.interpretAndOptimize(tree, context, pbProject);

    if (candidateTree != null) {
      trees.add(candidateTree);
    }
  }

  fpb.runCommandQueue();

  for (var tree in trees) {
    await fpb.genAITree(tree, tree.context, true);
  }

  for (var tree in trees) {
    await fpb.genAITree(tree, tree.context, false);
  }

  fpb.executePostGenTasks();

  exitCode = 0;
}

// TODO: Find way to optimize
Future<List<PBIntermediateTree>> treeHasMaster(PBIntermediateTree tree) async {
  var forest = [tree];
  for (var element in tree) {
    if (element is PBSharedMasterNode && element.parent != null) {
      var tempTree = PBIntermediateTree(name: element.name)
        ..rootNode = element
        ..tree_type = TREE_TYPE.VIEW
        ..generationViewData = PBGenerationViewData();

      var stack = <PBIntermediateNode>[];
      stack.add(element);

      // Passing all Component's children and their children's children
      // Also remove all of them from the old tree
      while (stack.isNotEmpty) {
        var currentNode = stack.removeLast();
        var tempChildren = tree.childrenOf(currentNode);
        stack.addAll(tempChildren);
        if (tempChildren.isNotEmpty) {
          tempTree.addEdges(currentNode, tempChildren);
        }
        tree.remove(currentNode);
      }

      forest.add(tempTree);

      var newInstance = PBSharedInstanceIntermediateNode(
        Uuid().v4(),
        element.frame,
        SYMBOL_ID: element.SYMBOL_ID,
        prototypeNode: element.prototypeNode,
        name: element.name,
        originalRef: element.originalRef,
      )
        ..layoutCrossAxisSizing = element.layoutCrossAxisSizing
        ..layoutMainAxisSizing = element.layoutMainAxisSizing
        ..constraints = element.constraints
        ..auxiliaryData = element.auxiliaryData;
      tree.replaceNode(element, newInstance);
    }
  }

  return forest;
}

/// Populates the corresponding fields of the [MainInfo] object with the
/// corresponding [arguments].
///
/// Remember that [MainInfo] is a Singleton, therefore, nothing its going to
/// be return from the function. When you use [MainInfo] again, its going to
/// contain the proper values from [arguments]
void collectArguments(ArgResults arguments) {
  var info = MainInfo();

  info.configuration =
      generateConfiguration(p.normalize(arguments['config-path']));

  /// Detect platform
  info.platform = Platform.operatingSystem;

  info.figmaOauthToken = arguments['oauth'];
  info.figmaKey = arguments['figKey'];
  info.figmaProjectID = arguments['fig'];

  info.designFilePath = arguments['path'];
  if (arguments['pbdl-in'] != null) {
    info.pbdlPath = arguments['pbdl-in'];
  }

  info.designType = determineDesignTypeFromArgs(arguments);
  info.exportStyles = !arguments['exclude-styles'];
  info.projectName ??= arguments['project-name'];

  /// If outputPath is empty, assume we are outputting to design file path
  info.outputPath = arguments['out'] ??
      p.dirname(info.designFilePath ?? Directory.current.path);

  info.exportPBDL = arguments['export-pbdl'] ?? false;

  /// In the future when we are generating certain dart files only.
  /// At the moment we are only generating in the flutter project.
  info.pngPath = p.join(info.genProjectPath, 'lib/assets/images');
}

/// Determine the [MainInfo.designType] from the [arguments]
///
/// If [arguments] include `figKey` or `fig`, that implies that [MainInfo.designType]
/// should be [DesignType.FIGMA]. If there is a `path`, then the [MainInfo.designType]
/// should be [DesignType.SKETCH]. Otherwise, if it includes the flag `pndl-in`, the type
/// is [DesignType.PBDL].Finally, if none of the [DesignType] applies, its going to default
/// to [DesignType.UNKNOWN].
DesignType determineDesignTypeFromArgs(ArgResults arguments) {
  if ((arguments['figKey'] != null || arguments['oauth'] != null) &&
      arguments['fig'] != null) {
    return DesignType.FIGMA;
  } else if (arguments['path'] != null) {
    return DesignType.SKETCH;
  } else if (arguments['pbdl-in'] != null) {
    return DesignType.PBDL;
  }
  return DesignType.UNKNOWN;
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

  addToAmplitude();
}

/// Generating the [PBConfiguration] based in the configuration file in [path]
PBConfiguration generateConfiguration(String path) {
  var configuration;
  try {
    ///SET CONFIGURATION
    // Setting configurations globally
    configuration =
        PBConfiguration.fromJson(json.decode(File(path).readAsStringSync()));
  } catch (e, stackTrace) {
    Sentry.captureException(e, stackTrace: stackTrace);
  }
  configuration ??= PBConfiguration.genericConfiguration();
  return configuration;
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
    Uri.parse(lambdaEndpt),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: body,
  );
}

/// Returns true if `args` contains two or more
/// types of intake to parabeac-core
bool hasTooManyArgs(ArgResults args) {
  var hasSketch = args['path'] != null;
  var hasFigma =
      args['figKey'] != null || args['fig'] != null || args['oauth'] != null;
  var hasPbdl = args['pbdl-in'] != null;

  var hasAll = hasSketch && hasFigma && hasPbdl;

  return hasAll || !(hasSketch ^ hasFigma ^ hasPbdl);
}

/// Returns true if `args` does not contain any intake
/// to parabeac-core
bool hasTooFewArgs(ArgResults args) {
  var hasSketch = args['path'] != null;
  var hasFigma =
      (args['figKey'] != null || args['oauth'] != null) && args['fig'] != null;
  var hasPbdl = args['pbdl-in'] != null;

  return !(hasSketch || hasFigma || hasPbdl);
}
