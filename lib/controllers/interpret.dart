import 'dart:convert';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_aggregation_service.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_linker_service.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_alignment_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_layout_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_plugin_control_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_symbol_linker_service.dart';
import 'package:pbdl/pbdl.dart';
import 'package:quick_log/quick_log.dart';
import 'package:path/path.dart' as p;

class Interpret {
  var log = Logger('Interpret');

  Interpret._internal();

  static final Interpret _interpret = Interpret._internal();

  factory Interpret({PBConfiguration configuration}) {
    _interpret.configuration ??= configuration;
    _interpret._pbPrototypeLinkerService ??= PBPrototypeLinkerService();
    return _interpret;
  }

  PBProject _pbProject;
  PBPrototypeLinkerService _pbPrototypeLinkerService;
  PBConfiguration configuration;

  void init(String projectName, PBConfiguration configuration) {
    this.configuration ??= configuration;
    log = Logger(runtimeType.toString());
    // _interpret._pbSymbolLinkerService = PBSymbolLinkerService();
    // _interpret._pbPrototypeLinkerService = PBPrototypeLinkerService();
  }

  Future<PBProject> interpretAndOptimize(PBDLProject project) async {
    _pbProject = PBProject.fromJson(project.toJson());

    _pbProject.projectAbsPath =
        p.join(MainInfo().outputPath, MainInfo().projectName);

    _pbProject.forest = await Future.wait(_pbProject.forest
        .map((tree) async => await _generateScreen(tree))
        .toList());
    _pbProject.forest.removeWhere((element) => element == null);

    // TODO: do this in just one go
    await PBPrototypeAggregationService().linkDanglingPrototypeNodes();

    return _pbProject;
  }

  Future<PBIntermediateTree> _generateScreen(
      PBIntermediateTree intermediateTree) async {
    if (intermediateTree.rootNode == null) {
      return intermediateTree;
    }

    var currentContext = createContext(intermediateTree);
    intermediateTree.rootNode.currentContext = currentContext;

    var stateNode = AbstractIntermediateNodeFactory.interpretStateManagement(
        intermediateTree.rootNode);

    // Remove non-default state management nodes by returning `null`
    if (stateNode == null) {
      return null;
    }

    await PBSymbolLinkerService().linkSymbols(intermediateTree.rootNode);

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

  /// Creates a [PBContext] from the `config` and the current `tree`
  PBContext createContext(PBIntermediateTree tree) => PBContext(configuration)
    ..project = _pbProject
    ..tree = tree
    ..screenTopLeftCorner = tree.rootNode.topLeftCorner
    ..screenBottomRightCorner = tree.rootNode.bottomRightCorner;

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
