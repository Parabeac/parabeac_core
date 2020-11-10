import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/pb_widget_manager.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_linker_service.dart';
import 'package:parabeac_core/input/helper/node_tree.dart';
import 'package:parabeac_core/input/helper/page.dart';
import 'package:parabeac_core/input/helper/page_item.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_group.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_item.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
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
  PBIntermediateTree _pb_intermediate_tree;
  PBSymbolLinkerService _pbSymbolLinkerService;
  PBPrototypeLinkerService _pbPrototypeLinkerService;
  PBGenerationManager _generationManager;

  void init(String projectName) {
    log = Logger(runtimeType.toString());
    this.projectName = projectName;
    _interpret._pbSymbolLinkerService = PBSymbolLinkerService();
    _interpret._pbPrototypeLinkerService = PBPrototypeLinkerService();
  }

  Future<PBIntermediateTree> interpretAndOptimize(NodeTree tree) async {
    _pb_intermediate_tree = PBIntermediateTree(projectName, tree.sharedStyles);

    ///3rd Party Symbols
    if (tree.miscPages != null) {
      for (var i = 0; i < tree.miscPages?.length; i++) {
        _pb_intermediate_tree.groups
            .add((await _generateGroup(tree.miscPages[i])));
      }
    }

    /// Main Pages
    if (tree.pages != null) {
      for (var i = 0; i < tree.pages?.length; i++) {
        _pb_intermediate_tree.groups.add((await _generateGroup(tree.pages[i])));
      }
    }

    return _pb_intermediate_tree;
  }

  Future<PBIntermediateGroup> _generateGroup(Page group) async {
    var intermediateGroup = PBIntermediateGroup(group.name.toLowerCase());
    var pageItems = group.getPageItems();
    for (var i = 0; i < pageItems.length; i++) {
      var item = await _generateScreen(pageItems[i]);
      String itemType;
      if (item is InheritedScaffold) {
        itemType = 'SCREEN';
      } else if (item is PBSharedMasterNode) {
        itemType = 'SHARED';
      } else {
        itemType = 'MISC';
      }

      if (item != null) {
        log.fine(
            'Processed \'${item.name}\' in group \'${group.name}\' with item type: \'${itemType}\'');

        var newItem = PBIntermediateItem(item, itemType);

        ///Searching for the root item.
        if (newItem.node is InheritedScaffold) {
          _pb_intermediate_tree.rootItem ??= newItem;
        }
        intermediateGroup.addItem(newItem);
      }
    }
    return intermediateGroup;
  }

  Future<PBIntermediateNode> _generateScreen(PageItem item) async {
    var currentContext = PBContext(
        jsonConfigurations:
            MainInfo().configurations ?? MainInfo().defaultConfigs);

    var parentComponent = item.root;

    var stopwatch = Stopwatch()..start();

    /// VisualGenerationService
    var parentVisualIntermediateNode = await _visualGenerationService(
        parentComponent, currentContext, stopwatch);

    ///
    /// pre-layout generation service for plugin nodes.
    /// NOTE Disabled Plugin Control Service for right now
    ///
    var stopwatch1 = Stopwatch()..start();
    var parentPreLayoutIntermediateNode = await _pluginService(
        parentVisualIntermediateNode, currentContext, stopwatch1);

    var stopwatch2 = Stopwatch()..start();

    /// LayoutGenerationService

    var parentLayoutIntermediateNode = await _layoutGenerationService(
        parentPreLayoutIntermediateNode, currentContext, stopwatch2);

    var stopwatch3 = Stopwatch()..start();

    /// AlignGenerationService
    var parentAlignIntermediateNode = await _alignGenerationService(
        parentLayoutIntermediateNode, currentContext, stopwatch3);

    return parentAlignIntermediateNode;
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
      parentPreLayoutIntermediateNode =
          parentVisualIntermediateNode; //parentVisualIntermediateNode;
    }

    PBIntermediateNode parentLayoutIntermediateNode;

    /// LayoutGenerationService
    try {
      parentLayoutIntermediateNode =
          PBLayoutGenerationService(currentContext: currentContext)
              .injectNodes(parentPreLayoutIntermediateNode);
    } catch (e, stackTrace) {
      await MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
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
      parentAlignIntermediateNode = parentLayoutIntermediateNode;
    }

    return parentAlignIntermediateNode;
  }

  Future<PBIntermediateNode> _visualGenerationService(
      var component, var context, var stopwatch) async {
    /// VisualGenerationService
    PBIntermediateNode node;
    try {
      node = await PBVisualGenerationService(component, currentContext: context)
          .getIntermediateTree();
    } catch (e, stackTrace) {
      await MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
    }
    // print(
    //     'Visual Generation Service executed in ${stopwatch.elapsedMilliseconds} milliseconds.');
    stopwatch.stop();
    node = await _pbSymbolLinkerService.linkSymbols(node);
    return node;
  }

  Future<PBIntermediateNode> _pluginService(
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
      node = parentnode;
    }
    // print(
    //     'Pre-Layout Service executed in ${stopwatch.elapsedMilliseconds} milliseconds.');
    stopwatch1.stop();
    return node;
  }

  Future<PBIntermediateNode> _layoutGenerationService(
      PBIntermediateNode parentNode, var context, var stopwatch2) async {
    PBIntermediateNode node;
    try {
      node = PBLayoutGenerationService(currentContext: context)
          .injectNodes(parentNode);
    } catch (e, stackTrace) {
      await MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
      node = parentNode;
    }

    node = await _pbPrototypeLinkerService.linkPrototypeNodes(node);
    // print(
    //     'Layout Generation Service executed in ${stopwatch.elapsedMilliseconds} milliseconds.');
    stopwatch2.stop();
    return node;
  }

  Future<PBIntermediateNode> _alignGenerationService(
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
      node = parentnode;
    }
    // print(
    //     'Align Generation Service executed in ${stopwatch.elapsedMilliseconds} milliseconds.');
    stopwatch3.stop();
    return node;
  }
}
