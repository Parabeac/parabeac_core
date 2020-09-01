import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/generators/pb_widget_manager.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/helper/sketch_node_tree.dart';
import 'package:parabeac_core/input/helper/sketch_page.dart';
import 'package:parabeac_core/input/helper/sketch_page_item.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
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
  PBGenerationManager _generationManager;

  void init(String projectName) {
    log = Logger(runtimeType.toString());
    this.projectName = projectName;
    _interpret._pbSymbolLinkerService = PBSymbolLinkerService();
  }

  Future<PBIntermediateTree> interpretAndOptimize(SketchNodeTree tree) async {
    _pb_intermediate_tree = PBIntermediateTree(projectName);

    ///3rd Party Symbols
    if (tree.miscPages != null) {
      for (var i = 0; i < tree.miscPages?.length; i++) {
        _pb_intermediate_tree.groups
            .add((await _generateGroup(tree.miscPages[i])));
      }
    }

    /// Main Sketch Pages
    if (tree.pages != null) {
      for (var i = 0; i < tree.pages?.length; i++) {
        _pb_intermediate_tree.groups.add((await _generateGroup(tree.pages[i])));
      }
    }

    return _pb_intermediate_tree;
  }

  Future<PBIntermediateGroup> _generateGroup(SketchPage group) async {
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
      log.fine(
          'Processed \'${item.name}\' in group \'${group.name}\' with item type: \'${itemType}\'');

      if (item != null) {
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

  Future<PBIntermediateNode> _generateScreen(SketchPageItem item) async {
    var currentContext = PBContext(
        jsonConfigurations:
            MainInfo().configurations ?? MainInfo().defaultConfigs);

    var parentComponent = item.root;
    PBIntermediateNode parentVisualIntermediateNode;

    var stopwatch = Stopwatch()..start();

    /// VisualGenerationService
    try {
      parentVisualIntermediateNode = await PBVisualGenerationService(
              parentComponent,
              currentContext: currentContext)
          .getIntermediateTree();
    } catch (e, stackTrace) {
      // await MainInfo().sentry.captureException(
      //       exception: e,
      //       stackTrace: stackTrace,
      //     );
      log.error(e.toString());
    }
    // print(
    //     'Visual Generation Service executed in ${stopwatch.elapsedMilliseconds} milliseconds.');
    stopwatch.stop();
    var stopwatch1 = Stopwatch()..start();

    parentVisualIntermediateNode =
        await _pbSymbolLinkerService.linkSymbols(parentVisualIntermediateNode);

    ///
    /// pre-layout generation service for plugin nodes.
    /// NOTE Disabled Plugin Control Service for right now
    ///
    PBIntermediateNode parentPreLayoutIntermediateNode;
    try {
      parentPreLayoutIntermediateNode = PBPluginControlService(
              parentVisualIntermediateNode,
              currentContext: currentContext)
          .convertAndModifyPluginNodeTree();
    } catch (e, stackTrace) {
      // await MainInfo().sentry.captureException(
      //       exception: e,
      //       stackTrace: stackTrace,
      //     );
      log.error(e.toString());
      parentPreLayoutIntermediateNode = parentVisualIntermediateNode;
    }
    // print(
    //     'Pre-Layout Service executed in ${stopwatch.elapsedMilliseconds} milliseconds.');
    stopwatch1.stop();
    var stopwatch2 = Stopwatch()..start();

    PBIntermediateNode parentLayoutIntermediateNode;

    /// LayoutGenerationService
    try {
      parentLayoutIntermediateNode =
          PBLayoutGenerationService(currentContext: currentContext)
              .injectNodes(parentPreLayoutIntermediateNode);
    } catch (e, stackTrace) {
      // await MainInfo().sentry.captureException(
      //       exception: e,
      //       stackTrace: stackTrace,
      //     );
      log.error(e.toString());
      parentLayoutIntermediateNode = parentPreLayoutIntermediateNode;
    }
    var parentAlignIntermediateNode;
    // print(
    //     'Layout Generation Service executed in ${stopwatch.elapsedMilliseconds} milliseconds.');
    stopwatch2.stop();
    var stopwatch3 = Stopwatch()..start();

    /// AlignGenerationService
    try {
      parentAlignIntermediateNode = PBAlignGenerationService(
              parentLayoutIntermediateNode,
              currentContext: currentContext)
          .addAlignmentToLayouts();
    } catch (e, stackTrace) {
      // await MainInfo().sentry.captureException(
      //       exception: e,
      //       stackTrace: stackTrace,
      //     );
      log.error(e.toString());
      parentAlignIntermediateNode = parentLayoutIntermediateNode;
    }
    // print(
    //     'Align Generation Service executed in ${stopwatch.elapsedMilliseconds} milliseconds.');
    stopwatch3.stop();

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
      // await MainInfo().sentry.captureException(
      //       exception: e,
      //       stackTrace: stackTrace,
      //     );
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
      // await MainInfo().sentry.captureException(
      //       exception: e,
      //       stackTrace: stackTrace,
      //     );
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
      // await MainInfo().sentry.captureException(
      //       exception: e,
      //       stackTrace: stackTrace,
      //     );
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
      // await MainInfo().sentry.captureException(
      //       exception: e,
      //       stackTrace: stackTrace,
      //     );
      log.error(e.toString());
      parentAlignIntermediateNode = parentLayoutIntermediateNode;
    }

    return parentAlignIntermediateNode;
  }
}
