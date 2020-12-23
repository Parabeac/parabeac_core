import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:parabeac_core/generation/generators/value_objects/pb_generation_configuration.dart';
import 'package:recase/recase.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
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

  ///The [GenerationConfiguration] that is going to be use in the generation of the code
  ///
  ///This is going to be defaulted to [StatefulGenerationConfiguration] if nothing else is specified.
  GenerationConfiguration generationConfiguration;

  Map<String, GenerationConfiguration> configurations = {
    'Provider': ProviderGenerationConfiguration(),
    'None': StatefulGenerationConfiguraiton(),
  };

  FlutterProjectBuilder({this.projectName, this.mainTree}) {
    pathToFlutterProject = '${projectName}/';
    generationConfiguration =
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

    await generationConfiguration.initializeFileStructure(
        pathToFlutterProject, mainTree);

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

  void _populateProject() {
    var fileStruct = generationConfiguration.fileStructureStrategy;
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
            generationConfiguration != null) {
          page = generationConfiguration.setStatefulNode(intermediateItem.node,
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
