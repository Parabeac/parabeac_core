import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:archive/archive.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/input/figma/helper/figma_asset_processor.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_state_management_linker.dart';
import 'package:quick_log/quick_log.dart';

// String pathToFlutterProject = '${MainInfo().outputPath}/temp/';

/// The [FlutterProjectBuilder] generates the actual flutter project,
/// where the generated dart code will reside for the [project].
///
/// The [FlutterProjectBuilder] will construct the necessary files within the
/// [flutterDir] with the name of [projectName].
/// Finally, it's going to generate all the required code by utilizing the [generationConfiguration].
/// Make sure the [FlutterProjectBuilder] is getting the directory path that will contain the flutter project.
/// For example, if the Flutter project were to be `my/awesome/path/FlutterProject,`
/// the [flutterDir] would be `my/awesome/path,` while the project name is `FlutterProject.`
class FlutterProjectBuilder {
  PBProject project;

  Logger log;

  PBPageWriter pageWriter;

  /// The path of the directory where the [project] is going to be generated at.
  final String flutterDir;

  /// The name that will be used for the generation of the [project]
  ///
  /// If no [projectName] is provided, the [PBProject.projectName] will
  /// be used as the default value.
  String projectName;

  /// The absolute path for the generated [project]
  String genProjectAbsPath;

  ///The [GenerationConfiguration] that is going to be use in the generation of the code
  ///
  ///This is going to be defaulted to [GenerationConfiguration] if nothing else is specified.
  GenerationConfiguration generationConfiguration;

  FlutterProjectBuilder(
    this.generationConfiguration, {
    this.project,
    this.pageWriter,
    this.projectName,
    this.genProjectAbsPath,
    this.flutterDir,
  }) {
    log = Logger(runtimeType.toString());

    projectName ??= project.projectName;
    genProjectAbsPath ??= p.join(flutterDir, projectName);

    if (genProjectAbsPath == null) {
      log.error(
          '[genProjectAbsPath] is null, caused by not providing both [projectName] & [flutterDir] or providing [genProjectAbsPath]');
      throw NullThrownError();
    }

    generationConfiguration.pageWriter = pageWriter;
  }

  Future<void> convertToFlutterProject({List<ArchiveFile> rawImages}) async {
    try {
      var createResult = Process.runSync('flutter', ['create', projectName],
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

    await Directory(p.join(genProjectAbsPath, 'assets/images'))
        .create(recursive: true)
        .catchError((e) {
      log.error(e.toString());
    });

    if (MainInfo().figmaProjectID != null &&
        MainInfo().figmaProjectID.isNotEmpty) {
      log.info('Processing remaining images...');
      await FigmaAssetProcessor().processImageQueue();
    }

    Process.runSync(
        p.join(MainInfo().cwd.path,
            '/lib/generation/helperScripts/shell-proxy.sh'),
        [
          'mv ${p.join('./pngs', '*')} ${p.join(genProjectAbsPath, 'assets/images/')}'
        ],
        runInShell: true,
        environment: Platform.environment,
        workingDirectory: MainInfo().outputPath);

    // Add all images
    if (rawImages != null) {
      for (var image in rawImages) {
        if (image.name != null) {
          var f = File(p.setExtension(
              p.join(genProjectAbsPath, 'assets/images/',
                  image.name.replaceAll(' ', '')),
              '.png'));
          f.writeAsBytesSync(image.content);
        }
      }
    }

    // generate shared Styles if any found
    if (project.sharedStyles != null &&
        project.sharedStyles.isNotEmpty &&
        MainInfo().exportStyles) {
      try {
        Directory(p.join(genProjectAbsPath, 'lib/document/'))
            .createSync(recursive: true);

        WriteStyleClasses(genProjectAbsPath);

        var s =
            File(p.join(genProjectAbsPath, 'lib/document/shared_props.g.dart'))
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
        p.join(MainInfo().cwd.path,
            '/lib/generation/helperScripts/shell-proxy.sh'),
        ['rm -rf .dart_tool/build'],
        runInShell: true,
        environment: Platform.environment,
        workingDirectory: MainInfo().outputPath);

    // Remove pngs folder
    Process.runSync(
        p.join(MainInfo().cwd.path,
            '/lib/generation/helperScripts/shell-proxy.sh'),
        ['rm -rf ${p.join(MainInfo().outputPath, '/pngs')}'],
        runInShell: true,
        environment: Platform.environment,
        workingDirectory: MainInfo().outputPath);

    log.info(
      Process.runSync(
              'dart',
              [
                'format',
                '${p.join(genProjectAbsPath, 'bin')}',
                '${p.join(genProjectAbsPath, 'lib')}',
                '${p.join(genProjectAbsPath, 'test')}'
              ],
              workingDirectory: MainInfo().outputPath)
          .stdout,
    );
  }
}

void WriteStyleClasses(String pathToFlutterProject) {
  var s = File(p.join(pathToFlutterProject, 'lib/document/Style.g.dart'))
      .openWrite(mode: FileMode.write, encoding: utf8);
  s.write('''
import 'dart:ui';
import 'package:flutter/material.dart';

class SK_Fill {
  Color color;
  bool isEnabled;
  SK_Fill(this.color, [this.isEnabled = true]);
}

class SK_Border {
  bool isEnabled;
  double fillType;
  Color color;
  double thickness;
  SK_Border(this.isEnabled, this.fillType, this.color, this.thickness);
}

class SK_BorderOptions {
  bool isEnabled;
  List dashPattern;
  int lineCapStyle;
  int lineJoinStyle;
  SK_BorderOptions(this.isEnabled, this.dashPattern, this.lineCapStyle, this.lineJoinStyle);
}

class SK_Style {
  Color backgroundColor;
  List<SK_Fill> fills;
  List<SK_Border> borders;
  SK_BorderOptions borderOptions;
  TextStyle textStyle;
  bool hasShadow;
  SK_Style(this.backgroundColor, this.fills, this.borders, this.borderOptions,this.textStyle, [this.hasShadow = false]);
}
''');

  s.close();
}
