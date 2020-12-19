import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
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

String pathToFlutterProject = '${MainInfo().outputPath}';

class FlutterProjectBuilder {
  String projectName;
  String pathToIntermiateFile;
  PBIntermediateTree mainTree;

  var log = Logger('Project Builder');

  ///For right now we are placing all [PBSharedMasterNode]s in a single page
  final bool _symbolsSinglePage = true;

  final String SYMBOL_DIR_NAME = 'symbols';

  FlutterProjectBuilder(
      {this.projectName, this.pathToIntermiateFile, this.mainTree}) {
    pathToFlutterProject += '${projectName}/';
    if (pathToIntermiateFile == null) {
      log.info(
          'Flutter Project Builder must have a JSON file in intermediate format passed to `pathToIntermediateFile`');
      return;
    }
  }

  void convertToFlutterProject({List<ArchiveFile> rawImages}) async {
    try {
      var createResult = Process.runSync(
        'flutter',
        ['create', projectName],
        workingDirectory: MainInfo().outputPath,
        runInShell: true,
      );
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

    if (MainInfo().platform == 'WIN') {
      Process.runSync(
          '${MainInfo().cwd.path}/lib/generation/helperScripts/shell-proxy.bat',
          [
            'move ${MainInfo().outputPath}/pngs/* ${pathToFlutterProject}assets/images/'
                .replaceAll('/', '\\')
          ],
          runInShell: true,
          environment: Platform.environment,
          workingDirectory: '${pathToFlutterProject}assets/');
    } else {
      Process.runSync(
          '${MainInfo().cwd.path}/lib/generation/helperScripts/shell-proxy.sh',
          [
            'mv ${MainInfo().outputPath}/pngs/* ${pathToFlutterProject}assets/images/'
          ],
          runInShell: true,
          environment: Platform.environment,
          workingDirectory: '${pathToFlutterProject}assets/');
    }

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

    ///First traversal here (Add imports)
    await _traverseTree(true);

    ///Second traversal here (Find imports)
    await _traverseTree(false);

    var l = File('${pathToFlutterProject}lib/main.dart').readAsLinesSync();
    var s = File('${pathToFlutterProject}lib/main.dart')
        .openWrite(mode: FileMode.write, encoding: utf8);
    for (var i = 0; i < l.length; i++) {
      s.writeln(l[i]);
    }
    await s.close();

    //Cleanup
    if (MainInfo().platform == 'WIN') {
      //windows specific cleanup
      Process.runSync(
          '${MainInfo().cwd.path}/lib/generation/helperScripts/shell-proxy.bat',
          ['rmdir /s /q .dart_tool/build'],
          runInShell: true,
          environment: Platform.environment,
          workingDirectory: '${MainInfo().outputPath}');
      Process.runSync(
          '${MainInfo().cwd.path}/lib/generation/helperScripts/shell-proxy.bat',
          ['rmdir /s /q pngs'],
          runInShell: true,
          environment: Platform.environment,
          workingDirectory: '${MainInfo().outputPath}');
    } else {
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
          workingDirectory: MainInfo().outputPath);
    }

    log.info(
      Process.runSync(
              'dartfmt',
              [
                '-w',
                '${pathToFlutterProject}bin',
                '${pathToFlutterProject}lib',
                '${pathToFlutterProject}test'
              ],
              runInShell: true,
              workingDirectory: MainInfo().outputPath)
          .stdout,
    );
  }

  /// Method that traverses the tree to add imports on the first traversal,
  /// and retrieve imports and write the file the second time
  void _traverseTree(bool isFirstTraversal) async {
    var pageWriter = PBFlutterWriter();

    for (var directory in mainTree.groups) {
      var directoryName = directory.name.snakeCase;
      var flutterGenerator;
      var importSet = <String>[];
      var bodyBuffer, constructorBuffer;
      var isSymbolsDir =
          directory.name == SYMBOL_DIR_NAME && _symbolsSinglePage;

      if (!isFirstTraversal) {
        await Directory('${projectName}/lib/screens/${directoryName}')
            .create(recursive: true);
      }

      // Create single FlutterGenerator for all symbols
      if (isSymbolsDir) {
        flutterGenerator = PBFlutterGenerator(pageWriter);
        bodyBuffer = StringBuffer();
      }

      for (var intermediateItem in directory.items) {
        var fileName = intermediateItem.node.name ?? 'defaultName';

        var name = isSymbolsDir ? SYMBOL_DIR_NAME : fileName;
        var symbolFilePath =
            '${projectName}/lib/screens/${directoryName}/${name.snakeCase}.dart';
        var fileNamePath =
            '${projectName}/lib/screens/${directoryName}/${fileName.snakeCase}.dart';
        // TODO: Need FlutterGenerator for each page because otherwise
        // we'd add all imports to every single dart page. Discuss alternatives
        if (!isSymbolsDir) {
          flutterGenerator = PBFlutterGenerator(pageWriter);
        }

        // Add to cache if node is scaffold or symbol master
        if (intermediateItem.node is InheritedScaffold && isFirstTraversal) {
          PBGenCache().addToCache(intermediateItem.node.UUID, symbolFilePath);
        } else if (intermediateItem.node is PBSharedMasterNode &&
            isFirstTraversal) {
          PBGenCache().addToCache(
              (intermediateItem.node as PBSharedMasterNode).SYMBOL_ID,
              symbolFilePath);
        }

        // Check if there are any imports needed for this screen
        if (!isFirstTraversal) {
          isSymbolsDir
              ? importSet.addAll(ImportHelper.findImports(
                  intermediateItem.node, symbolFilePath))
              : flutterGenerator.imports.addAll(ImportHelper.findImports(
                  intermediateItem.node, fileNamePath));

          // Check if [InheritedScaffold] is the homescreen
          if (intermediateItem.node is InheritedScaffold &&
              (intermediateItem.node as InheritedScaffold).isHomeScreen) {
            var relPath = PBGenCache().getRelativePath(
                '${projectName}/lib/main.dart', intermediateItem.node.UUID);
            await pageWriter.writeMainScreenWithHome(intermediateItem.node.name,
                '${projectName}/lib/main.dart', relPath);
          }

          var page = flutterGenerator.generate(intermediateItem.node);

          // If writing symbols, write to buffer, otherwise write a file
          isSymbolsDir
              ? bodyBuffer.write(page)
              : pageWriter.write(page, fileNamePath);
        }
      }
      if (!isFirstTraversal) {
        if (isSymbolsDir) {
          var symbolPath =
              '${projectName}/lib/screens/${directoryName}/symbols.dart';
          importSet.add(flutterGenerator.generateImports());

          var importBuffer = StringBuffer();
          importSet.toSet().toList().forEach(importBuffer.write);

          pageWriter.write(
              (importBuffer?.toString() ?? '') +
                  (constructorBuffer?.toString() ?? '') +
                  bodyBuffer.toString(),
              symbolPath);
        }
        pageWriter.submitDependencies(projectName + '/pubspec.yaml');
      }
    }
  }
}
