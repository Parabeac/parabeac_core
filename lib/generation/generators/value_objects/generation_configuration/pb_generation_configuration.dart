import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/command_invoker.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/entry_file_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/export_platform_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/orientation_builder_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/responsive_layout_builder_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_screen_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_platform_orientation_generation_mixin.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/flutter_file_structure_strategy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';
import 'package:quick_log/quick_log.dart';
import 'package:recase/recase.dart';
import 'package:path/path.dart' as p;

abstract class GenerationConfiguration with PBPlatformOrientationGeneration {
  FileStructureStrategy fileStructureStrategy;

  Logger logger;

  /// The [_head] of a [Middlware] link list.
  Middleware _head;

  ///The manager in charge of the independent [PBGenerator]s by providing an interface for adding imports, global variables, etc.
  ///
  ///The default [PBGenerationManager] will be [PBFlutterGenerator]
  PBGenerationManager generationManager;

  PBPlatformOrientationLinkerService poLinker;

  ImportHelper _importProcessor;

  @Deprecated('Use [FileStructureCommands instead of using the pageWriter.]')

  /// PageWriter to be used for generation
  PBPageWriter pageWriter = PBFlutterWriter();

  final Map<String, String> _dependencies = {};
  Iterable<MapEntry<String, String>> get dependencies => _dependencies.entries;

  /// List of observers that will be notified when a new command is added.
  final commandObservers = <CommandInvoker>[];

  /// Queue where [FileStructureCommand]s can be placed for later execution.
  ///
  /// Specifically, once the [setUpConfiguration] has been called and finished executing
  /// for the [GenerationConfiguration]. The purpose of this list, is for callers that might want
  /// to execute [FileStructureCommand]s before the [GenerationConfiguration] is done with [setUpConfiguration].
  /// Those [FileStructureCommand]s could just be added to the list.
  final List<FileStructureCommand> commandQueue = [];

  GenerationConfiguration() {
    logger = Logger(runtimeType.toString());
    _importProcessor ??= ImportHelper();
    generationManager ??=
        PBFlutterGenerator(_importProcessor, data: PBGenerationViewData());
    poLinker ??= PBPlatformOrientationLinkerService();
  }

  ///This is going to modify the [PBIntermediateNode] in order to affect the structural patterns or file structure produced.
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    node = await _head.applyMiddleware(node);

    return node;
  }

  ///Applying the registered [Middleware] to all the [PBIntermediateNode]s within the [PBIntermediateTree]
  Future<PBIntermediateTree> _applyMiddleware(PBIntermediateTree tree) async {
    tree.rootNode =
        (await Future.wait(tree.map(applyMiddleware).toList())).first;

    return tree.rootNode == null ? null : tree;
  }

  Future<void> generateTrees(
      List<PBIntermediateTree> trees, PBProject project) async {
    for (var tree in trees) {
      tree.rootNode.currentContext.generationManager = generationManager;

      tree.data.addImport(FlutterImport('material.dart', 'flutter'));
      generationManager.data = tree.data;

      // Relative path to the file to create
      var relPath = p.join(tree.name.snakeCase, tree.identifier);

      // Change relative path if current tree is part of multi-platform setup
      if (poLinker.screenHasMultiplePlatforms(tree.identifier)) {
        var platformFolder =
            poLinker.stripPlatform(tree.rootNode.managerData.platform);
        relPath = p.join(tree.identifier, platformFolder, tree.identifier);
      }
      if (tree.isHomeScreen()) {
        await _setMainScreen(tree, relPath, project.projectName);
      }
      tree = await _applyMiddleware(tree);
      if (tree == null) {
        continue;
      }
      fileStructureStrategy.commandCreated(_createCommand(tree, project));
    }
  }

  ///Generates the [PBIntermediateTree]s within the [pb_project]
  Future<void> generateProject(PBProject pb_project) async {
    ///First we are going to perform a dry run in the generation to
    ///gather all the necessary information
    await setUpConfiguration(pb_project);

    fileStructureStrategy.dryRunMode = true;
    fileStructureStrategy.addFileObserver(_importProcessor);
    pb_project.fileStructureStrategy = fileStructureStrategy;

    pb_project.lockData = true;
    commandQueue.forEach(fileStructureStrategy.commandCreated);
    await generateTrees(pb_project.forest, pb_project);
    pb_project.lockData = false;

    ///After the dry run is complete, then we are able to create the actual files.
    fileStructureStrategy.dryRunMode = false;

    commandQueue.forEach(fileStructureStrategy.commandCreated);
    commandQueue.clear();
    await generateTrees(pb_project.forest, pb_project);

    await _commitDependencies(pb_project.projectAbsPath);
  }

  FileStructureCommand _createCommand(
      PBIntermediateTree tree, PBProject project) {
    var command;
    _addDependencyImports(tree, project.projectName);
    if (poLinker.screenHasMultiplePlatforms(tree.identifier)) {
      getPlatformOrientationName(tree.rootNode);

      command = ExportPlatformCommand(
        tree.UUID,
        tree.rootNode.currentContext.tree.data.platform,
        tree.identifier,
        tree.rootNode.name.snakeCase,
        generationManager.generate(tree.rootNode),
      );
    } else if (tree.isScreen()) {
      command = WriteScreenCommand(
        tree.UUID,
        tree.identifier,
        tree.name.snakeCase,
        generationManager.generate(tree.rootNode),
      );
    } else {
      var relativePath = tree.name.snakeCase; //symbols

      command = WriteSymbolCommand(
        tree.UUID,
        tree.identifier,
        generationManager.generate(tree.rootNode),
        relativePath: relativePath,
      );
    }

    return command;
  }

  /// Method that traverses `tree`'s dependencies and looks for an import path from
  /// [ImportHelper].
  ///
  /// If an import path is found, it will be added to the `tree`'s data. The package format
  /// for imports is going to be enforced, therefore, [packageName] is going to be
  /// a required parameter.
  void _addDependencyImports(PBIntermediateTree tree, String packageName) {
    var iter = tree.dependentsOn;
    var addImport = tree.rootNode.managerData.addImport;

    while (iter.moveNext()) {
      _importProcessor.getFormattedImports(
        iter.current.UUID,
        importMapper: (import) => addImport(FlutterImport(import, packageName)),
      );
    }
  }

  void registerMiddleware(Middleware middleware) {
    if (middleware != null) {
      if (_head == null) {
        _head = middleware;
      } else {
        middleware.nextMiddleware = _head;
        _head = middleware;

        middleware.generationManager = generationManager;
      }
    }
  }

  ///Configure the required classes for the [PBGenerationConfiguration]
  Future<void> setUpConfiguration(PBProject pbProject) async {
    fileStructureStrategy = FlutterFileStructureStrategy(
        pbProject.projectAbsPath, pageWriter, pbProject);
    commandObservers.add(fileStructureStrategy);

    logger.info('Setting up the directories');
    await fileStructureStrategy.setUpDirectories();
  }

  Future<void> _commitDependencies(String projectPath) async {
    var writer = pageWriter;
    if (writer is PBFlutterWriter) {
      writer.submitDependencies(p.join(projectPath, 'pubspec.yaml'));
    }
  }

  Future<void> _setMainScreen(
      PBIntermediateTree tree, String outputMain, String packageName) async {
    var nodeInfo = _determineNode(tree, outputMain);
    fileStructureStrategy.commandCreated(EntryFileCommand(
        entryScreenName: nodeInfo[0],
        entryScreenImport: _importProcessor
            .getFormattedImports(tree.UUID,
                importMapper: (import) => FlutterImport(import, packageName))
            .join('\n')));
  }

  List<String> _determineNode(PBIntermediateTree tree, String outputMain) {
    var rootName = tree.rootNode.name;
    if (rootName.contains('_')) {
      rootName = rootName.split('_')[0].pascalCase;
    }
    var currentMap = poLinker.getPlatformOrientationData(rootName);
    var className = [rootName.pascalCase, ''];
    if (currentMap.length > 1) {
      className[0] += 'PlatformBuilder';
      className[1] =
          rootName.snakeCase + '/${rootName.snakeCase}_platform_builder.dart';
    }
    return className;
  }

  Future<void> generatePlatformAndOrientationInstance(PBProject mainTree) {
    var currentMap = poLinker.getWhoNeedsAbstractInstance();

    currentMap.forEach((screenName, platformsMap) {
      var rawImports = getPlatformImports(screenName);

      rawImports.add(p.join(
        fileStructureStrategy.GENERATED_PROJECT_PATH,
        OrientationBuilderCommand.DIR_TO_ORIENTATION_BUILDER,
        OrientationBuilderCommand.NAME_TO_ORIENTAION_BUILDER,
      ));
      rawImports.add(p.join(
        fileStructureStrategy.GENERATED_PROJECT_PATH,
        ResponsiveLayoutBuilderCommand.DIR_TO_RESPONSIVE_LAYOUT,
        ResponsiveLayoutBuilderCommand.NAME_TO_RESPONSIVE_LAYOUT,
      ));

      var newCommand = generatePlatformInstance(
          platformsMap, screenName, fileStructureStrategy, rawImports);

      if (newCommand != null) {
        commandObservers
            .forEach((observer) => observer.commandCreated(newCommand));
      }
    });
  }

  Set<String> getPlatformImports(String screenName) {
    var platformOrientationMap =
        poLinker.getPlatformOrientationData(screenName);
    var imports = <String>{};
    platformOrientationMap.forEach((key, map) {
      map.forEach((key, tree) {
        imports.addAll(_importProcessor.getImport(tree.UUID));
      });
    });
    return imports;
  }
}
