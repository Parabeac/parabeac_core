import 'dart:convert';
import 'dart:io';

import 'package:parabeac_core/controllers/controller.dart';
import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/writers/pb_traversal_adapter_writer.dart';
import 'package:parabeac_core/generation/pre-generation/pre_generation_service.dart';
import 'package:parabeac_core/input/figma/entities/layers/frame.dart';
import 'package:parabeac_core/input/figma/helper/figma_project.dart';
import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:quick_log/quick_log.dart';

import 'interpret.dart';
import 'main_info.dart';

class FigmaController extends Controller {
  ///SERVICE
  @override
  var log = Logger('FigmaController');

  FigmaController();

  @override
  void convertFile(
    var jsonFigma,
    var outputPath,
    var configurationPath,
    var configType, {
    bool jsonOnly = false,
    DesignProject designProject,
  }) async {
    configure(configurationPath, configType);

    var figmaProject = await generateFigmaTree(jsonFigma, outputPath);

    figmaProject = declareScaffolds(figmaProject);

    await super.convertFile(
      jsonFigma,
      outputPath,
      configurationPath,
      configType,
      designProject: figmaProject,
    );
  }

  FigmaProject generateFigmaTree(var jsonFigma, var projectname) {
    try {
      return FigmaProject(projectname, jsonFigma);
    } catch (e, stackTrace) {
      print(e);
      return null;
    }
  }

  /// This method was required for Figma, so we could
  /// detect which `FigmaFrame` were Scaffolds or Containers
  FigmaProject declareScaffolds(FigmaProject tree) {
    for (var page in tree.pages) {
      for (var item in page.getPageItems()) {
        if (item.designNode is FigmaFrame) {
          (item.designNode as FigmaFrame).isScaffold = true;
        }
      }
    }
    return tree;
  }
}
