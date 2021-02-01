import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
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

class Interpret {
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
  PBGenerationManager _generationManager;

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
        _pb_project.forest.addAll((await _generateGroup(tree.miscPages[i])));
      }
    }

    /// Main Pages
    if (tree.pages != null) {
      for (var i = 0; i < tree.pages?.length; i++) {
        _pb_project.forest.addAll((await _generateGroup(tree.pages[i])));
      }
    }

    return _pb_project;
  }

  Future<Iterable<PBIntermediateTree>> _generateGroup(DesignPage group) async {
    var tempForest = <PBIntermediateTree>[];
    var pageItems = group.getPageItems();
    for (var i = 0; i < pageItems.length; i++) {
      var item = await _generateScreen(pageItems[i]);
      if (item != null && item.rootNode != null) {
        var tempTree = item;
        tempTree.name = group.name;

        if (item.rootNode is InheritedScaffold) {
          tempTree.tree_type = TREE_TYPE.SCREEN;
        } else if (item.rootNode is PBSharedMasterNode) {
          tempTree.tree_type = TREE_TYPE.VIEW;
        } else {
          tempTree.tree_type = TREE_TYPE.MISC;
        }

        if (item != null) {
          log.fine(
              'Processed \'${item.name}\' in group \'${group.name}\' with item type: \'${tempTree.tree_type}\'');

          tempTree.rootNode;
          tempForest.add(tempTree);
        }
      }
    }
    return tempForest;
  }

  Future<PBIntermediateTree> _generateScreen(DesignScreen item) async {
    var currentContext = PBContext(
        jsonConfigurations:
            MainInfo().configurations ?? MainInfo().defaultConfigs);

    var parentComponent = item.designNode;

    var stopwatch = Stopwatch()..start();

    /// VisualGenerationService
    var intermediateTree = PBIntermediateTree(item.designNode.name);
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

  Future<PBIntermediateNode> generateNonRootItem(DesignNode root) async {
    var currentContext = PBContext(
        jsonConfigurations:
            MainInfo().configurations ?? MainInfo().defaultConfigs);

    PBIntermediateNode parentVisualIntermediateNode;

    /// VisualGenerationService
    try {
      parentVisualIntermediateNode =
          await PBVisualGenerationService(root, currentContext: currentContext)
              .getIntermediateTree();
    } catch (e, stackTrace) {
      await MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
      log.error('at PBVisualGenerationService from generateNonRootItem');
    }

    ///
    /// pre-layout generation service for plugin nodes.
    ///
    PBIntermediateNode parentPreLayoutIntermediateNode;
    try {
      parentPreLayoutIntermediateNode = PBPluginControlService(
              parentVisualIntermediateNode,
              currentContext: currentContext)
          .convertAndModifyPluginNodeTree();
    } catch (e, stackTrace) {
      await MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
      log.error('at PBPluginControlService from generateNonRootItem');
      parentPreLayoutIntermediateNode =
          parentVisualIntermediateNode; //parentVisualIntermediateNode;
    }

    PBIntermediateNode parentLayoutIntermediateNode;

    /// LayoutGenerationService
    try {
      parentLayoutIntermediateNode =
          PBLayoutGenerationService(currentContext: currentContext)
              .extractLayouts(parentPreLayoutIntermediateNode);
    } catch (e, stackTrace) {
      await MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
      log.error('at PBLayoutGenerationService from generateNonRootItem');
      parentLayoutIntermediateNode = parentPreLayoutIntermediateNode;
    }
    var parentAlignIntermediateNode;

    /// AlignGenerationService
    try {
      parentAlignIntermediateNode = PBAlignGenerationService(
              parentLayoutIntermediateNode,
              currentContext: currentContext)
          .addAlignmentToLayouts();
    } catch (e, stackTrace) {
      await MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
      log.error('at PBAlignGenerationService from generateNonRootItem');
      parentAlignIntermediateNode = parentLayoutIntermediateNode;
    }

    return parentAlignIntermediateNode;
  }

  // TODO: refactor this method and/or `getIntermediateTree`
  // to not take the [ignoreStates] variable.
  Future<PBIntermediateNode> visualGenerationService(
      var component, var context, var stopwatch,
      {bool ignoreStates = false}) async {
    /// VisualGenerationService
    PBIntermediateNode node;
    try {
      node = await PBVisualGenerationService(component, currentContext: context)
          .getIntermediateTree(ignoreStates: ignoreStates);
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
