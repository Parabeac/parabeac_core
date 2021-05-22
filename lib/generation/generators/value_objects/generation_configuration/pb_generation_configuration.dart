import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/util/topo_tree_iterator.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/command_invoker.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/export_platform_command.dart';
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
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
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

  final Set<Middleware> _middleware = {};
  Set<Middleware> get middlewares => _middleware;

  ///The project that contains the node for all the pages.
  PBProject pbProject;

  ///The manager in charge of the independent [PBGenerator]s by providing an interface for adding imports, global variables, etc.
  ///
  ///The default [PBGenerationManager] will be [PBFlutterGenerator]
  PBGenerationManager generationManager;

  ImportHelper _importProcessor;

  /// PageWriter to be used for generation
  PBPageWriter pageWriter = PBFlutterWriter(); // Default to Flutter

  final Map<String, String> _dependencies = {};
  Iterable<MapEntry<String, String>> get dependencies => _dependencies.entries;

  /// List of observers that will be notified when a new command is added.
  final commandObservers = <CommandInvoker>[];

  GenerationConfiguration() {
    logger = Logger(runtimeType.toString());
    _importProcessor ??= ImportHelper();
    generationManager ??=
        PBFlutterGenerator(_importProcessor, data: PBGenerationViewData());
  }

  ///This is going to modify the [PBIntermediateNode] in order to affect the structural patterns or file structure produced.
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    var it = _middleware.iterator;
    while (it.moveNext()) {
      node = await it.current.applyMiddleware(node);
    }
    return node;
  }

  Future<PBIntermediateNode> conditionsToApplyMiddleware(
      PBIntermediateNode node) async {
    if ((node is PBSharedInstanceIntermediateNode && _isMasterState(node)) ||
        (node?.auxiliaryData?.stateGraph?.states?.isNotEmpty ?? false)) {
      return await applyMiddleware(node);
    }
    return node;
  }

  bool _isMasterState(PBSharedInstanceIntermediateNode node) {
    if (node.isMasterState) {
      return true;
    }
    var symbolMaster =
        PBSymbolStorage().getSharedMasterNodeBySymbolID(node.SYMBOL_ID);
    return symbolMaster?.auxiliaryData?.stateGraph?.states?.isNotEmpty ?? false;
  }

  Future<PBIntermediateNode> _iterateNode(PBIntermediateNode node) async {
    var stack = <PBIntermediateNode>[node];
    while (stack.isNotEmpty) {
      var currentNode = stack.removeLast();

      /// Add all children to the stack
      if (currentNode.child != null) {
        stack.add(currentNode.child);
      } else if (currentNode is PBLayoutIntermediateNode) {
        currentNode.children.forEach((node) {
          stack.add(node);
        });
      }

      /// Apply incoming function to all nodes
      await conditionsToApplyMiddleware(currentNode);
    }
    return node;
  }

  ///generates the Project based on the [pb_project]
  Future<void> generateProject(PBProject pb_project) async {
    pbProject = pb_project;
    var poLinker = PBPlatformOrientationLinkerService();

    await setUpConfiguration();
    pbProject.fileStructureStrategy = fileStructureStrategy;
    var trees = IntermediateTopoIterator(pbProject.forest);

    while (trees.moveNext()) {
      var tree = trees.current;
      tree.rootNode.currentContext.generationManager = generationManager;

      tree.data.addImport('package:flutter/material.dart');
      generationManager.data = tree.data;
      var fileName = tree.rootNode?.name?.snakeCase ?? 'no_name_found';

      // Relative path to the file to create
      var relPath = '${tree.name.snakeCase}/$fileName';
      // Change relative path if current tree is part of multi-platform setup
      if (poLinker.screenHasMultiplePlatforms(tree.rootNode.name)) {
        var platformFolder =
            poLinker.stripPlatform(tree.rootNode.managerData.platform);
        relPath = '$fileName/$platformFolder/$fileName';
      }
      if (tree.rootNode is InheritedScaffold &&
          (tree.rootNode as InheritedScaffold).isHomeScreen) {
        await _setMainScreen(tree.rootNode, '$relPath.dart');
      }
      await _iterateNode(tree.rootNode);

      if (poLinker.screenHasMultiplePlatforms(tree.rootNode.name)) {
        getPlatformOrientationName(tree.rootNode);
        var command = ExportPlatformCommand(
          tree.UUID,
          tree.rootNode.currentContext.tree.data.platform,
          '$fileName',
          '${tree.rootNode.name.snakeCase}.dart',
          generationManager.generate(tree.rootNode),
        );

        if (_importProcessor.imports.isNotEmpty) {
          var treePath = p.join(
              pbProject.projectAbsPath, command.WIDGET_PATH, '$fileName.dart');
          _traverseTreeForImports(tree, treePath);
        }
        commandObservers
            .forEach((observer) => observer.commandCreated(command));
      } else if (tree.rootNode is InheritedScaffold) {
        var command = WriteScreenCommand(
          tree.UUID,
          '$fileName.dart',
          '${tree.name.snakeCase}',
          generationManager.generate(tree.rootNode),
        );

        if (_importProcessor.imports.isNotEmpty) {
          var treePath = p.join(pbProject.projectAbsPath,
              WriteScreenCommand.SCREEN_PATH, '$fileName.dart');
          _traverseTreeForImports(tree, treePath);
        }

        commandObservers.forEach(
          (observer) => observer.commandCreated(command),
        );
      } else {
        var command = WriteSymbolCommand(
          tree.UUID,
          '$fileName.dart',
          generationManager.generate(tree.rootNode),
          relativePath: tree.name.snakeCase + '/',
        );

        if (_importProcessor.imports.isNotEmpty) {
          var treePath = p.join(pbProject.projectAbsPath, command.SYMBOL_PATH,
              command.relativePath, '$fileName.dart');
          _traverseTreeForImports(tree, treePath);
        }

        commandObservers.forEach(
          (observer) => observer.commandCreated(command),
        );
      }
    }
    await _commitDependencies(pb_project.projectName);
  }

  /// Method that traverses `tree`'s dependencies and looks for an import path from
  /// [ImportHelper].
  /// 
  /// If an import path is found, it will be added to the `tree`'s data.
  void _traverseTreeForImports(PBIntermediateTree tree, String treeAbsPath) {
    var iter = tree.dependentOn;

    if (iter.moveNext()) {
      var dependency = iter.current;
      for (var key in _importProcessor.imports.keys) {
        if (key == dependency.UUID) {
          var relativePath = PBGenCache().getRelativePathFromPaths(
              treeAbsPath, _importProcessor.imports[key]);
          tree.rootNode.managerData.addImport(relativePath);
        }
      }
    }
  }

  void registerMiddleware(Middleware middleware) {
    if (middleware != null) {
      middleware.generationManager = generationManager;
      _middleware.add(middleware);
    }
  }

  Future<void> setUpConfiguration() async {
    fileStructureStrategy = FlutterFileStructureStrategy(
        pbProject.projectAbsPath, pageWriter, pbProject);
    commandObservers.add(fileStructureStrategy);
    fileStructureStrategy.addFileObserver(_importProcessor);

    // Execute command queue
    var queue = pbProject.genProjectData.commandQueue;
    while (queue.isNotEmpty) {
      var command = queue.removeLast();
      commandObservers.forEach((observer) => observer.commandCreated(command));
    }
    logger.info('Setting up the directories');
    await fileStructureStrategy.setUpDirectories();
  }

  Future<void> _commitDependencies(String projectName) async {
    var writer = pageWriter;
    if (writer is PBFlutterWriter) {
      writer.submitDependencies(projectName + '/pubspec.yaml');
    }
  }

  Future<void> _setMainScreen(InheritedScaffold node, String outputMain) async {
    var writer = pageWriter;
    if (writer is PBFlutterWriter) {
      await writer.writeMainScreenWithHome(
          node.name,
          p.join(fileStructureStrategy.GENERATED_PROJECT_PATH, 'lib/main.dart'),
          'screens/$outputMain');
    }
  }

  Future<void> generatePlatformAndOrientationInstance(PBProject mainTree) {
    var currentMap =
        PBPlatformOrientationLinkerService().getWhoNeedsAbstractInstance();

    currentMap.forEach((screenName, platformsMap) {
      var rawImports = getPlatformImports(screenName);

      rawImports.add(p.join(
        mainTree.fileStructureStrategy.GENERATED_PROJECT_PATH +
            OrientationBuilderCommand.DIR_TO_ORIENTATION_BUILDER +
            OrientationBuilderCommand.NAME_TO_ORIENTAION_BUILDER,
      ));
      rawImports.add(p.join(
        mainTree.fileStructureStrategy.GENERATED_PROJECT_PATH +
            ResponsiveLayoutBuilderCommand.DIR_TO_RESPONSIVE_LAYOUT +
            ResponsiveLayoutBuilderCommand.NAME_TO_RESPONSIVE_LAYOUT,
      ));

      var newCommand = generatePlatformInstance(
          platformsMap, screenName, mainTree, rawImports);

      if (newCommand != null) {
        commandObservers
            .forEach((observer) => observer.commandCreated(newCommand));
      }
    });
  }

  Set<String> getPlatformImports(String screenName) {
    var platformOrientationMap = PBPlatformOrientationLinkerService()
        .getPlatformOrientationData(screenName);
    var imports = <String>{};
    platformOrientationMap.forEach((key, map) {
      map.forEach((key, tree) {
        imports.add(_importProcessor.getImport(tree.UUID));
      });
    });
    // TODO: add import to responsive layout builder

    return imports;
  }
}
