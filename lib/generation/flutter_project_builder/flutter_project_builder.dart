import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:parabeac_core/generation/generators/state_management/provider_management.dart';
import 'package:parabeac_core/generation/generators/state_management/state_management_config.dart';
import 'package:parabeac_core/generation/generators/state_management/stateful_management.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_state_management_linker.dart';
import 'package:recase/recase.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:quick_log/quick_log.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/input/figma/helper/image_helper.dart'
    as image_helper;

import 'import_helper.dart';

String pathToFlutterProject = '${MainInfo().outputPath}/temp/';

class FlutterProjectBuilder {
  String projectName;
  PBIntermediateTree mainTree;

  var log = Logger('Project Builder');

  final String SYMBOL_DIR_NAME = 'symbols';

  Map<String, StateManagementGenerator> configurations = {
    'Provider': ProviderGeneratorWrapper(),
    'None': StatefulManagement(),
  };

  StateManagementGenerator stateManagementConfig;

  FlutterProjectBuilder({this.projectName, this.mainTree}) {
    pathToFlutterProject = '${projectName}/';
    stateManagementConfig =
        configurations[MainInfo().configurations['state-management']];
  }

  void convertToFlutterProject({List<ArchiveFile> rawImages}) async {
    try {
      var createResult = Process.runSync('flutter', ['create', '$projectName'],
          workingDirectory: MainInfo().outputPath);
      if (createResult.stderr != null && createResult.stderr.isNotEmpty) {
        log.error(createResult.stderr);
      } else {
        log.info(createResult.stdout);
      }
    } catch (error, stackTrace) {
      await MainInfo().sentry.captureException(
            exception: error,
            stackTrace: stackTrace,
          );
      log.error(error.toString());
    }

    // Add Pubspec Assets Lines.
    var list = File('${pathToFlutterProject}pubspec.yaml').readAsLinesSync();
    list.replaceRange(42, 44, ['  assets:', '    - assets/images/']);
    var sink = File('${pathToFlutterProject}pubspec.yaml')
        .openWrite(mode: FileMode.write, encoding: utf8);
    for (var i = 0; i < list.length; i++) {
      sink.writeln(list[i]);
    }
    await sink.close();

    await Directory('${pathToFlutterProject}assets/images')
        .create(recursive: true)
        .then((value) => {
              // print(value),
            })
        .catchError((e) {
      // print(e);
      log.error(e.toString());
    });

    if (MainInfo().figmaProjectID != null &&
        MainInfo().figmaProjectID.isNotEmpty) {
      log.info('Processing remaining images...');
      await image_helper.processImageQueue();
    }

    Process.runSync(
        '${MainInfo().cwd.path}/lib/generation/helperScripts/shell-proxy.sh',
        [
          'mv ${MainInfo().outputPath}/pngs/* ${pathToFlutterProject}assets/images/'
        ],
        runInShell: true,
        environment: Platform.environment,
        workingDirectory: '${pathToFlutterProject}assets/');

    // Add all images
    if (rawImages != null) {
      for (var image in rawImages) {
        if (image.name != null) {
          var f = File(
              '${pathToFlutterProject}assets/images/${image.name.replaceAll(" ", "")}.png');
          f.writeAsBytesSync(image.content);
        }
      }
    }

    // Wait for State Management nodes to finish being interpreted
    await Future.wait(PBStateManagementLinker().stateQueue);

    // generate shared Styles if any found
    if (mainTree.sharedStyles != null && mainTree.sharedStyles.isNotEmpty) {
      await Directory('${pathToFlutterProject}lib/document/')
          .create(recursive: true)
          .then((value) {
        var s = File('${pathToFlutterProject}lib/document/shared_props.g.dart')
            .openWrite(mode: FileMode.write, encoding: utf8);
        s.write('''import 'dart:ui';
              import 'package:flutter/material.dart';
              
              ''');
        for (var sharedStyle in mainTree.sharedStyles) {
          s.write(sharedStyle.generate() + '\n');
        }
        s.close();
      }).catchError((e) {
        log.error(e.toString());
      });
    }

    await _initializeProject();

    await _populateProject();

    var l = File('${pathToFlutterProject}lib/main.dart').readAsLinesSync();
    var s = File('${pathToFlutterProject}lib/main.dart')
        .openWrite(mode: FileMode.write, encoding: utf8);
    for (var i = 0; i < l.length; i++) {
      s.writeln(l[i]);
    }
    await s.close();

    Process.runSync(
        '${MainInfo().cwd.path}/lib/generation/helperScripts/shell-proxy.sh',
        ['rm -rf .dart_tool/build'],
        runInShell: true,
        environment: Platform.environment,
        workingDirectory: '${MainInfo().outputPath}');

    // Remove pngs folder
    Process.runSync(
        '${MainInfo().cwd.path}/lib/generation/helperScripts/shell-proxy.sh',
        ['rm -rf ${MainInfo().outputPath}/pngs'],
        runInShell: true,
        environment: Platform.environment,
        workingDirectory: '${MainInfo().outputPath}');

    log.info(
      Process.runSync(
              'dartfmt',
              [
                '-w',
                '${pathToFlutterProject}bin',
                '${pathToFlutterProject}lib',
                '${pathToFlutterProject}test'
              ],
              workingDirectory: MainInfo().outputPath)
          .stdout,
    );
  }

  void _initializeProject() async {
    for (var directory in mainTree.groups) {
      var directoryName = directory.name.snakeCase;
      var screenDirectoryName = '${projectName}/lib/screens/${directoryName}';
      var viewDirectoryName = '${projectName}/lib/views/${directoryName}';

      /// Establish Directories where needed.
      if (directory.items.isNotEmpty) {
        for (var i = 0; i < directory.items.length; i++) {
          var containsScreens = false;
          var containsViews = false;
          if (directory.items[i].node is InheritedScaffold &&
              !containsScreens) {
            containsScreens = true;
            await Directory(screenDirectoryName).create(recursive: true);
          }
          if (directory.items[i].node is PBSharedMasterNode && !containsViews) {
            containsViews = true;
            await Directory(viewDirectoryName).create(recursive: true);
          }
          if (containsScreens && containsViews) {
            continue;
          }
        }
      }

      /// Add import Info.
      for (var intermediateItem in directory.items) {
        // Add to cache if node is scaffold or symbol master
        if (intermediateItem.node is InheritedScaffold) {
          PBGenCache().addToCache(intermediateItem.node.UUID,
              '${screenDirectoryName}/${intermediateItem.node.name.snakeCase}.dart');
        } else if (intermediateItem.node is PBSharedMasterNode) {
          PBGenCache().addToCache(
              (intermediateItem.node as PBSharedMasterNode).SYMBOL_ID,
              '${viewDirectoryName}/${intermediateItem.node.name.snakeCase}.g.dart');
        } else {
          PBGenCache().addToCache(intermediateItem.node.UUID,
              '${screenDirectoryName}/${intermediateItem.node.name.snakeCase}.g.dart');
        }
      }
    }
  }

  void _populateProject() {
    var pageWriter = PBFlutterWriter();
    for (var directory in mainTree.groups) {
      var directoryName = directory.name.snakeCase;

      for (var intermediateItem in directory.items) {
        var flutterGenerator = PBFlutterGenerator(pageWriter);
        var fileName = intermediateItem.node.name;
        var screenFilePath =
            '${projectName}/lib/screens/${directoryName}/${fileName.snakeCase}.dart';
        var viewFilePath =
            '${projectName}/lib/views/${directoryName}/${fileName.snakeCase}.g.dart';
        ImportHelper.findImports(
                intermediateItem.node,
                intermediateItem.node is InheritedScaffold
                    ? screenFilePath
                    : viewFilePath)
            .forEach(flutterGenerator.addImport);
        var page;
        if (intermediateItem.node.auxiliaryData.stateGraph.states.isNotEmpty &&
            stateManagementConfig != null) {
          page = stateManagementConfig.setStatefulNode(intermediateItem.node,
              flutterGenerator, '${projectName}/lib/views/${directoryName}');
        } else {
          page = flutterGenerator.generate(intermediateItem.node);
        }
        pageWriter.write(
            page,
            intermediateItem.node is InheritedScaffold
                ? screenFilePath
                : viewFilePath);
      }

      pageWriter.submitDependencies(projectName + '/pubspec.yaml');
    }
  }
}
