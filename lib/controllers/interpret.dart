import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_linker_service.dart';
import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:parabeac_core/input/helper/design_page.dart';
import 'package:parabeac_core/input/helper/design_screen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_alignment_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_constraint_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_layout_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_plugin_control_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_symbol_linker_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_visual_generation_service.dart';
import 'package:quick_log/quick_log.dart';

import 'main_info.dart';

class Interpret {
  var log = Logger('Interpret');

  Interpret._internal();

  static final Interpret _interpret = Interpret._internal();

  factory Interpret() {
    return _interpret;
  }

  PBProject _pb_project;
  PBSymbolLinkerService _pbSymbolLinkerService;
  PBPrototypeLinkerService _pbPrototypeLinkerService;
  PBConfiguration configuration;

  void init(String projectName, PBConfiguration configuration) {
    this.configuration ??= configuration;
    log = Logger(runtimeType.toString());
    _interpret._pbSymbolLinkerService = PBSymbolLinkerService();
    _interpret._pbPrototypeLinkerService = PBPrototypeLinkerService();
  }

  Future<PBProject> interpretAndOptimize(
      DesignProject tree, String projectName, String projectPath) async {
    _pb_project = PBProject(projectName, projectPath, tree.sharedStyles);

    ///3rd Party Symbols
    if (tree.miscPages != null) {
      for (var i = 0; i < tree.miscPages?.length; i++) {
        _pb_project.forest
            .addAll((await _generateIntermediateTree(tree.miscPages[i])));
      }
    }

    /// Main Pages
    if (tree.pages != null) {
      for (var i = 0; i < tree.pages?.length; i++) {
        _pb_project.forest
            .addAll((await _generateIntermediateTree(tree.pages[i])));
      }
    }

    return _pb_project;
  }

  /// Taking a design page, returns a PBIntermediateTree verison of it
  Future<Iterable<PBIntermediateTree>> _generateIntermediateTree(
      DesignPage designPage) async {
    var tempForest = <PBIntermediateTree>[];
    var pageItems = designPage.getPageItems();
    for (var i = 0; i < pageItems.length; i++) {
      var tree = await _generateScreen(pageItems[i]);
      if (tree != null && tree.rootNode != null) {
        tree.name = designPage.name;

        tree.data = PBGenerationViewData();
        if (tree.isScreen()) {
          PBPlatformOrientationLinkerService()
              .addOrientationPlatformInformation(tree);
        }

        if (tree != null) {
          log.fine(
              'Processed \'${tree.name}\' in group \'${designPage.name}\' with item type: \'${tree.tree_type}\'');

          tempForest.add(tree);
        }
      }
    }
    return tempForest;
  }

  Future<PBIntermediateTree> _generateScreen(DesignScreen designScreen) async {
    var currentContext = PBContext(configuration);

    var parentComponent = designScreen.designNode;

    var stopwatch = Stopwatch()..start();

    /// VisualGenerationService
    var intermediateTree = PBIntermediateTree(designScreen.designNode.name);
    currentContext.tree = intermediateTree;
    currentContext.project = _pb_project;
    intermediateTree.rootNode = await visualGenerationService(
        parentComponent, currentContext, stopwatch);

    if (intermediateTree.rootNode == null) {
      return intermediateTree;
    }
    var aitServices = [
      PBPluginControlService().convertAndModifyPluginNodeTree,
      PBLayoutGenerationService().extractLayouts,
      PBConstraintGenerationService().implementConstraints,
      PBAlignGenerationService().addAlignmentToLayouts
    ];

    var builder = AITServiceBuilder(currentContext, intermediateTree, aitServices)
    .addTransformation((tree, context) {
      print(tree.hashCode);
      return Future.value(tree);
    });
    return builder.build();

  }

  // TODO: refactor this method and/or `getIntermediateTree`
  // to not take the [ignoreStates] variable.
  Future<PBIntermediateNode> visualGenerationService(
      var component, var context, var stopwatch,
      {bool ignoreStates = false}) async {
    /// VisualGenerationService
    PBIntermediateNode node;
    try {
      node = await PBVisualGenerationService(component,
              currentContext: context, ignoreStates: ignoreStates)
          .getIntermediateTree();
    } catch (e, stackTrace) {
      await MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
      log.error('at PBVisualGenerationService');
    }
    // print(
    //     'Visual Generation Service executed in ${stopwatch.elapsedMilliseconds} milliseconds.');
    stopwatch.stop();
    node = await _pbSymbolLinkerService.linkSymbols(node);
    return node;
  }


  }
