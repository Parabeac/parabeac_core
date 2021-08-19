import 'dart:convert';
import 'dart:io';
import 'package:parabeac_core/generation/flutter_project_builder/file_system_analyzer.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:path/path.dart' as p;

import 'package:archive/archive.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_state_management_linker.dart';
import 'package:quick_log/quick_log.dart';
import 'package:tuple/tuple.dart';

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
  /// The [PBProject] that will be converted into a Flutter project.
  PBProject project;

  /// Logger that prints consoles informatio
  static Logger log;

  // PBPageWriter pageWriter;

  ///The [GenerationConfiguration] that is going to be use in the generation of the code
  ///
  ///This is going to be defaulted to [GenerationConfiguration] if nothing else is specified.
  GenerationConfiguration generationConfiguration;

  FileSystemAnalyzer fileSystemAnalyzer;

  bool _configured = false;

  FlutterProjectBuilder(
    this.generationConfiguration,
    this.fileSystemAnalyzer, {
    this.project,
    // this.pageWriter,
  }) {
    log = Logger(runtimeType.toString());
    fileSystemAnalyzer ??= FileSystemAnalyzer(project.projectAbsPath);

    generationConfiguration.pageWriter = PBFlutterWriter();
    generationConfiguration.fileSystemAnalyzer = fileSystemAnalyzer;
  }

  /// Creating a Flutter project within the [projectDir] with the name of [flutterProjectName].
  ///
  /// Make sure that the [projectDir] does not contain the [flutterProjectName], it should only be
  /// the directory where the flutter project is going to be generated. Finally, the function
  /// is going to return a [Tuple2], [Tuple2.item1] being the path of the [flutterProjectName] and
  /// [Tuple2.item2] being the [ProcessResult.stdout] or [ProcessResult.stderr] depending
  /// on the [ProcessResult.exitCode]. If the [createAssetsDir] is `true`, its going to create
  /// the [assetsDir] within the flutter project.
  static Future<Tuple2> createFlutterProject(String flutterProjectName,
      {String projectDir,
      bool createAssetsDir = true,
      String assetsDir = 'assets/images/'}) {
    return Process.run('flutter', ['create', flutterProjectName],
            workingDirectory: projectDir, runInShell: true)
        .then((result) => Tuple2(p.join(projectDir, flutterProjectName),
            result.exitCode == 2 ? result.stderr : result.stdout))
        .then((tuple) async {
      if (createAssetsDir) {
        await Directory(p.join(tuple.item1, assetsDir))
            .create(recursive: true)
            .catchError((e) {
          log.error(e.toString());
        });
      }
      return tuple;
    }).catchError((onError) {
      MainInfo().captureException(onError);
      log.error(onError.toString());
    });
  }

  /// Formatting the flutter project that is at [projectPath].
  ///
  /// The formatter is going to be running within `[projectPath]bin/*`,
  /// `[projectPath]lib/*`, and `[projectPath]test/*` by using `dart format`.
  /// There is an option to set to set the current working directory of as [projectDir],
  static Future<dynamic> formatProject(String projectPath,
      {String projectDir}) {
    return Process.run(
            'dart',
            [
              'format',
              p.join(projectPath, 'bin'),
              p.join(projectPath, 'lib'),
              p.join(projectPath, 'test')
            ],
            workingDirectory: projectDir,
            runInShell: true)
        .then((result) => result.exitCode == 2 ? result.stderr : result.stdout)
        .catchError((error) {
      MainInfo().captureException(error);
      log.error(error.toString());
    });
  }

  Future<void> preGenTasks() async {
    _configured = true;
    await Future.wait([
      Future.wait(PBStateManagementLinker().stateQueue, eagerError: true),
      Process.run('rm', ['-rf', '.dart_tool/build'],
          runInShell: true,
          environment: Platform.environment,
          workingDirectory: MainInfo().outputPath),
      generationConfiguration.generateProject(project)
    ]);

    ;
  }

  Future<void> genAITree(PBIntermediateTree tree, PBContext context) async {
    if (!_configured) {
      /// Avoid changing the [_configured] from here, it might lead to async changes on the var
      throw Error();
    }

    await generationConfiguration.generateTree(tree, project, context, true);
    await generationConfiguration.generateTree(tree, project, context, false);
    generationConfiguration.generatePlatformAndOrientationInstance(project);
    await formatProject(project.projectAbsPath, projectDir: MainInfo().outputPath);
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
