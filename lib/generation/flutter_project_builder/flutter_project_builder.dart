import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:archive/archive.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
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
  PBProject project;

  var log = Logger('Project Builder');

  PBPageWriter pageWriter;

  ///The [GenerationConfiguration] that is going to be use in the generation of the code
  ///
  ///This is going to be defaulted to [GenerationConfiguration] if nothing else is specified.
  GenerationConfiguration generationConfiguration;

  FlutterProjectBuilder(this.generationConfiguration,
      {this.project, this.pageWriter}) {
    generationConfiguration.pageWriter = pageWriter;
  }

  Future<void> convertToFlutterProject({List<ArchiveFile> rawImages}) async {
    try {
      var createResult = Process.runSync(
          'flutter', ['create', '${project.projectName}'],
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

    await Directory(p.join(pathToFlutterProject, 'assets/images'))
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

    var pngsPath = p.join(MainInfo().outputPath, 'pngs', '*');
    Process.runSync(
        '${MainInfo().cwd.path}/lib/generation/helperScripts/shell-proxy.sh',
        [
          'mv $pngsPath ${pathToFlutterProject}assets/images/'
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
    if (project.sharedStyles != null &&
        project.sharedStyles.isNotEmpty &&
        MainInfo().exportStyles) {
      try {
        Directory('${pathToFlutterProject}lib/document/')
            .createSync(recursive: true);
        var s = File('${pathToFlutterProject}lib/document/shared_props.g.dart')
            .openWrite(mode: FileMode.write, encoding: utf8);

        s.write('''${FlutterImport('dart:ui', null)}
              ${FlutterImport('flutter/material.dart', null)}

              ''');
        for (var sharedStyle in project.sharedStyles) {
          s.write(sharedStyle.generate() + '\n');
        }
        await s.close();
      } catch (e) {
        log.error(e.toString());
      }
    }
    await Future.wait(PBStateManagementLinker().stateQueue, eagerError: true);

    await generationConfiguration.generateProject(project);
    await generationConfiguration
        .generatePlatformAndOrientationInstance(project);

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
