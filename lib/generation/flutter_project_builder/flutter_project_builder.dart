import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/bloc_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/provider_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/riverpod_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/stateful_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/input/figma/helper/figma_asset_processor.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_state_management_linker.dart';
import 'package:quick_log/quick_log.dart';

String pathToFlutterProject = '${MainInfo().outputPath}/temp/';

class FlutterProjectBuilder {
  String projectName;
  PBProject mainTree;

  var log = Logger('Project Builder');

  final String SYMBOL_DIR_NAME = 'symbols';

  ///The [GenerationConfiguration] that is going to be use in the generation of the code
  ///
  ///This is going to be defaulted to [GenerationConfiguration] if nothing else is specified.
  GenerationConfiguration generationConfiguration;

  Map<String, GenerationConfiguration> configurations = {
    'provider': ProviderGenerationConfiguration(),
    'bloc': BLoCGenerationConfiguration(),
    'riverpod': RiverpodGenerationConfiguration(),
    'none': StatefulGenerationConfiguration(),
  };

  final DEFAULT_CONFIGURATION = StatefulGenerationConfiguration();

  PBPageWriter pageWriter;

  FlutterProjectBuilder({this.projectName, this.mainTree, this.pageWriter}) {
    pathToFlutterProject = '${projectName}/';
    generationConfiguration = configurations[MainInfo()
            .configurations['state-management']
            .toString()
            .toLowerCase()] ??
        DEFAULT_CONFIGURATION;
    generationConfiguration.pageWriter = pageWriter;
    mainTree.projectName = projectName;
    mainTree.projectAbsPath = pathToFlutterProject;
  }

  Future<void> convertToFlutterProject({List<ArchiveFile> rawImages}) async {
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
      await FigmaAssetProcessor().processImageQueue();
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
    if (mainTree.sharedStyles != null &&
        mainTree.sharedStyles.isNotEmpty &&
        MainInfo().exportStyles) {
      try {
        Directory('${pathToFlutterProject}lib/document/')
            .createSync(recursive: true);
        var s = File('${pathToFlutterProject}lib/document/shared_props.g.dart')
            .openWrite(mode: FileMode.write, encoding: utf8);

        s.write('''import 'dart:ui';
              import 'package:flutter/material.dart';
              
              ''');
        for (var sharedStyle in mainTree.sharedStyles) {
          s.write(sharedStyle.generate() + '\n');
        }
        await s.close();
      } catch (e) {
        log.error(e.toString());
      }
    }
    await Future.wait(PBStateManagementLinker().stateQueue, eagerError: true);
    await generationConfiguration.generateProject(mainTree);

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
}
