import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:parabeac_core/analytics/analytics_constants.dart';
import 'package:parabeac_core/analytics/sentry_analytics_service.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/isolation_post_gen_task.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/global_styling/global_styling_aggregator.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_services/path_service.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/flutter_project_builder/file_system_analyzer.dart';
import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/component_isolation_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_plugin_list_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/services/design_to_pbdl/design_to_pbdl_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/design_to_pbdl/figma_to_pbdl_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/design_to_pbdl/json_to_pbdl_service.dart';
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
  FigmaToPBDLService(),
];
FileSystemAnalyzer fileSystemAnalyzer;
Interpret interpretService = Interpret();

///sets up parser
final parser = ArgParser()
  ..addOption('out', help: 'The output path', valueHelp: 'path', abbr: 'o')
  ..addOption('project-name', help: 'The name of the project', abbr: 'n')
  ..addOption(
    'config-path',
    help: 'Path of the configuration file',
    abbr: 'c',
    defaultsTo: p.setExtension(
        p.join('lib', 'configurations', 'configurations'), '.json'),
  )
  // '${p.setExtension(p.join('lib/configurations/', 'configurations'), '.json')}')
  ..addOption('fig', help: 'The ID of the figma file', abbr: 'f')
  ..addOption('figKey', help: 'Your personal API Key', abbr: 'k')
  ..addOption(
    'pbdl-in',
    help:
        'Takes in a Parabeac Design Logic (PBDL) JSON file and exports it to a project',
  )
  ..addOption('oauth', help: 'Figma OAuth Token')
  ..addOption(
    'folderArchitecture',
    help: 'Folder Architecture type to use.',
    allowedHelp: {
      'domain':
          'Default Option. Generates a domain-layered folder architecture.'
    },
  )
  ..addOption(
    'componentIsolation',
    help: 'Component Isolation configuration to use.',
    allowedHelp: {
      'widgetbook': 'Default option. Use widgetbook for component isolation.',
      'dashbook': 'Use dashbook for component isolation.',
      'none': 'Do not use any component isolation packages.',
    },
  )
  ..addOption(
    'project-type',
    help: 'Type of project to generate.',
    allowedHelp: {
      'screens': 'Default Option. Generate a full app.',
      'components': 'Generate a component package.',
      'themes': 'Generate theme information.',
    },
    aliases: ['level'],
  )
  ..addFlag('help',
      help: 'Displays this help information.', abbr: 'h', negatable: false)
  ..addFlag(
    'export-pbdl',
    help: 'This flag outputs Parabeac Design Logic (PBDL) in JSON format.',
    negatable: false,
  )
  ..addFlag('exclude-styles',
      help: 'If this flag is set, it will exclude output styles document');

Future<void> main(List<String> args) async {
  await runZonedGuarded(() async {
    await Sentry.init((p0) {
      p0.dsn =
          'https://6e011ce0d8cd4b7fb0ff284a23c5cb37@o433482.ingest.sentry.io/5388747';
      p0.tracesSampleRate = 1.0;
    });
    await runParabeac(args);
  }, (error, stackTrace) async {
    await Sentry.captureException(error);
    await Sentry.close();
  });
  await Sentry.close();
}

Future<void> runParabeac(List<String> args) async {
  Logger.writer = ConsolePrinter(minLevel: LogLevel.info);
  // Start sentry transaction
  SentryService.startTransaction(
    RUN_PARABEAC,
    'Conversion',
    description: 'Total runtime of parabeac_core.',
  );

  await checkConfigFile();
  var log = Logger('Main');
  var pubspec = File('pubspec.yaml');
  await pubspec.readAsString().then((String text) {
    Map yaml = loadYaml(text);
    log.info('Current version: ${yaml['version']}');
  });
  log.info(args.toString());

  MainInfo().cwd = Directory.current;

  var argResults = parser.parse(args);

  /// Check if no args passed or only -h/--help passed
  if (argResults['help']) {
    print('''
  ** PARABEAC HELP **
${parser.usage}
    ''');
    exit(0);
  }

  /// Pass MainInfo the argument results
  /// so it can interpret and store them for later use
  MainInfo().collectArguments(argResults);

  /// Register the PathService singleton
  /// for PBC to know in the future the type of architecture
  GetIt.I.registerSingleton<PathService>(PathService.fromConfiguration(
      MainInfo().configuration.folderArchitecture));

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
  if (MainInfo().configuration.exportPBDL) {
    exitCode = 0;
    await SentryService.finishTransaction(RUN_PARABEAC);
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

  /// Check whether there are any global styles to be generated.
  if (pbdl.globalStyles != null) {
    GlobalStylingAggregator.addPostGenTasks(fpb, pbdl.globalStyles);
  }

  SentryService.startChildTransactionFrom(
    RUN_PARABEAC,
    PRE_GEN,
    description: 'Tasks to be done before generating the project.',
  );
  await fpb.preGenTasks();
  await SentryService.finishTransaction(PRE_GEN);

  /// Get ComponentIsolationService (if any), and add it to the list of services
  var isolationConfiguration = ComponentIsolationConfiguration.getConfiguration(
    MainInfo().configuration.componentIsolation,
    pbProject.genProjectData,
    MainInfo().configuration.integrationLevel,
  );
  if (isolationConfiguration != null) {
    interpretService.aitHandlers.add(isolationConfiguration.service);
    fpb.postGenTasks.add(IsolationPostGenTask(
        isolationConfiguration.generator, fpb.generationConfiguration));
  }
  await indexFileFuture;

  var trees = <PBIntermediateTree>[];

  SentryService.startChildTransactionFrom(
    RUN_PARABEAC,
    INTERPRETATION,
    description:
        'Runs services that interpret and optimize PBIntermediateNodes.',
  );

  for (var tree in pbProject.forest) {
    var context = PBContext(processInfo.configuration);
    context.project = pbProject;

    /// Assuming that the [tree.rootNode] has the dimensions of the screen.
    context.screenFrame = Rectangle3D.fromPoints(
        tree.rootNode.frame.topLeft, tree.rootNode.frame.bottomRight);

    context.tree = tree;
    tree.context = context;

    SentryService.startChildTransactionFrom(
      INTERPRETATION,
      HANDLE_CHILDREN,
      description: 'Lets each node in the tree detect and handle its children.',
    );

    tree.forEach((child) => child.handleChildren(context));

    await SentryService.finishTransaction(HANDLE_CHILDREN);

    SentryService.startChildTransactionFrom(
      INTERPRETATION,
      INTERMEDIATE_SERVICES,
      description:
          'Runs a variety of services to the tree to map it closely to Flutter.',
    );

    var candidateTree =
        await interpretService.interpretAndOptimize(tree, context, pbProject);

    await SentryService.finishTransaction(INTERMEDIATE_SERVICES);

    if (candidateTree != null) {
      trees.add(candidateTree);
    }
  }

  await SentryService.finishTransaction(INTERPRETATION);

  SentryService.startChildTransactionFrom(
    RUN_PARABEAC,
    GENERATION,
    description:
        'Tasks that happen after interpretation of trees. These have to do with generating code, writing files, etc.',
  );

  SentryService.startChildTransactionFrom(
    GENERATION,
    COMMAND_QUEUE,
    description:
        'Run command queue, which contains tasks like writing screens, symbols, etc.',
  );
  fpb.runCommandQueue();
  await SentryService.finishTransaction(COMMAND_QUEUE);

  SentryService.startChildTransactionFrom(
    GENERATION,
    GEN_DRY_RUN,
    description: 'Dry run to gather necessary information from trees.',
  );
  for (var tree in trees) {
    await fpb.genAITree(tree, tree.context, true);
  }
  await SentryService.finishTransaction(GEN_DRY_RUN);

  SentryService.startChildTransactionFrom(
    GENERATION,
    GEN_AIT,
    description: 'Generates the code inside each tree.',
  );
  for (var tree in trees) {
    await fpb.genAITree(tree, tree.context, false);
  }
  await SentryService.finishTransaction(GEN_AIT);
  await SentryService.finishTransaction(GENERATION);

  SentryService.startChildTransactionFrom(
    RUN_PARABEAC,
    POST_GEN,
    description: 'Executes post generation tasks.',
  );
  fpb.executePostGenTasks();
  await SentryService.finishTransaction(POST_GEN);

  await SentryService.finishTransaction(RUN_PARABEAC);

  exitCode = 0;
}

// TODO: Find way to optimize
Future<List<PBIntermediateTree>> treeHasMaster(PBIntermediateTree tree) async {
  var forest = [tree];
  for (var element in tree) {
    if (element is PBSharedMasterNode && element.parent != null) {
      var elementConstraints = element.constraints.copyWith();

      /// Since this is now a [PBSharedMasterNode], we need to remove the constraints
      /// and pass them on to the instance.
      element.constraints = PBIntermediateConstraints.defaultConstraints();
      var tempTree = PBIntermediateTree(name: tree.name)
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
        ..constraints = elementConstraints
        ..auxiliaryData = element.auxiliaryData;
      tree.replaceNode(element, newInstance);
    }
  }

  return forest;
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
