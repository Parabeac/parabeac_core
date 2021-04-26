import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/controllers/utils/interpret_utils.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_linker_service.dart';
import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:parabeac_core/input/helper/design_page.dart';
import 'package:parabeac_core/input/helper/design_screen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_alignment_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_layout_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_plugin_control_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_symbol_linker_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_visual_generation_service.dart';
import 'package:meta/meta.dart';
import 'package:quick_log/quick_log.dart';

import 'main_info.dart';

class Interpret with InterpretUtils {
  var log = Logger('Interpret');

  Interpret._internal();

  static final Interpret _interpret = Interpret._internal();

  factory Interpret() {
    return _interpret;
  }

  @visibleForTesting
  String projectName;
  PBProject _pb_project;
  PBSymbolLinkerService _pbSymbolLinkerService;
  PBPrototypeLinkerService _pbPrototypeLinkerService;

  void init(String projectName) {
    log = Logger(runtimeType.toString());
    this.projectName = projectName;
    _interpret._pbSymbolLinkerService = PBSymbolLinkerService();
    _interpret._pbPrototypeLinkerService = PBPrototypeLinkerService();
  }

  Future<PBProject> interpretAndOptimize(DesignProject tree) async {
    _pb_project = PBProject(projectName, tree.sharedStyles);

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
      var currentScreen = await _generateScreen(pageItems[i]);
      if (currentScreen != null && currentScreen.rootNode != null) {
        var tempTree = currentScreen;
        tempTree.name = designPage.name;

        tempTree.data = PBGenerationViewData();
        if (currentScreen.rootNode is InheritedScaffold) {
          tempTree.data.platform = extractPlatform(designPage.name);

          tempTree.data.orientation = extractOrientation(
              tempTree.rootNode.bottomRightCorner,
              tempTree.rootNode.topLeftCorner);
        } else if (currentScreen.rootNode is PBSharedMasterNode) {
          tempTree.tree_type = TREE_TYPE.VIEW;
        } else {
          tempTree.tree_type = TREE_TYPE.MISC;
        }

        if (currentScreen != null) {
          log.fine(
              'Processed \'${currentScreen.name}\' in group \'${designPage.name}\' with item type: \'${tempTree.tree_type}\'');

          tempForest.add(tempTree);
        }
      }
    }
    return tempForest;
  }

  Future<PBIntermediateTree> _generateScreen(DesignScreen designScreen) async {
    var currentContext = PBContext(
        jsonConfigurations:
            MainInfo().configurations ?? MainInfo().defaultConfigs);

    var parentComponent = designScreen.designNode;

    var stopwatch = Stopwatch()..start();

    /// VisualGenerationService
    var intermediateTree = PBIntermediateTree(designScreen.designNode.name);
    currentContext.treeRoot = intermediateTree;
    currentContext.project = _pb_project;
    intermediateTree.rootNode = await visualGenerationService(
        parentComponent, currentContext, stopwatch);

    if (intermediateTree.rootNode == null) {
      return intermediateTree;
    }

    ///
    /// pre-layout generation service for plugin nodes.
    /// NOTE Disabled Plugin Control Service for right now
    ///
    var stopwatch1 = Stopwatch()..start();
    intermediateTree.rootNode = await pluginService(
        intermediateTree.rootNode, currentContext, stopwatch1);

    var stopwatch2 = Stopwatch()..start();

    /// LayoutGenerationService

    intermediateTree.rootNode = await layoutGenerationService(
        intermediateTree.rootNode, currentContext, stopwatch2);

    var stopwatch3 = Stopwatch()..start();

    /// AlignGenerationService
    intermediateTree.rootNode = await alignGenerationService(
        intermediateTree.rootNode, currentContext, stopwatch3);

    return intermediateTree;
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

  Future<PBIntermediateNode> pluginService(
      PBIntermediateNode parentnode, var context, var stopwatch1) async {
    PBIntermediateNode node;
    try {
      node = PBPluginControlService(parentnode, currentContext: context)
          .convertAndModifyPluginNodeTree();
    } catch (e, stackTrace) {
      await MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
      log.error('at PBPluginControlService');
      node = parentnode;
    }
    // print(
    //     'Pre-Layout Service executed in ${stopwatch.elapsedMilliseconds} milliseconds.');
    stopwatch1.stop();
    return node;
  }

  Future<PBIntermediateNode> layoutGenerationService(
      PBIntermediateNode parentNode, var context, var stopwatch2) async {
    PBIntermediateNode node;
    try {
      node = PBLayoutGenerationService(currentContext: context)
          .extractLayouts(parentNode);
    } catch (e, stackTrace) {
      await MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
      log.error('at PBLayoutGenerationService');
      node = parentNode;
    }

    node = await _pbPrototypeLinkerService.linkPrototypeNodes(node);
    // print(
    //     'Layout Generation Service executed in ${stopwatch.elapsedMilliseconds} milliseconds.');
    stopwatch2.stop();
    return node;
  }

  Future<PBIntermediateNode> alignGenerationService(
      PBIntermediateNode parentnode, var context, var stopwatch3) async {
    PBIntermediateNode node;

    /// This covers a case where the designer created an empty group. This would cause an issue as there is nothing to align.
    if (parentnode is TempGroupLayoutNode) {
      return null;
    }

    try {
      node = PBAlignGenerationService(parentnode, currentContext: context)
          .addAlignmentToLayouts();
    } catch (e, stackTrace) {
      await MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
      log.error('at PBAlignGenerationService');
      node = parentnode;
    }
    // print(
    //     'Align Generation Service executed in ${stopwatch.elapsedMilliseconds} milliseconds.');
    stopwatch3.stop();
    return node;
  }
}
