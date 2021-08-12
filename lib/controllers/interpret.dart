import 'dart:io';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_linker_service.dart';
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
import 'package:parabeac_core/interpret_and_optimize/services/pb_constraint_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_layout_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_plugin_control_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_symbol_linker_service.dart';
import 'package:pbdl/pbdl.dart';
import 'package:quick_log/quick_log.dart';
import 'package:tuple/tuple.dart';
import 'package:path/path.dart' as p;

class Interpret {
  Logger log;

  Interpret._internal();

  static final Interpret _interpret = Interpret._internal();

  factory Interpret() {
    _interpret.log = Logger(_interpret.runtimeType.toString());
    _interpret._pbPrototypeLinkerService ??= PBPrototypeLinkerService();
    return _interpret;
  }

  PBPrototypeLinkerService _pbPrototypeLinkerService;

  final List<AITHandler> aitHandlers = [
    PBSymbolLinkerService(),
    PBPluginControlService(),
    PBLayoutGenerationService(),
    PBConstraintGenerationService(),
    PBAlignGenerationService()
  ];

  Future<PBProject> interpretAndOptimize(
      PBDLProject project, PBConfiguration configuration,
      {List<AITHandler> handlers,
      PBContext context,
      AITServiceBuilder aitServiceBuilder}) async {
    handlers ??= aitHandlers;
    context ??= PBContext(configuration);

    aitServiceBuilder ??= AITServiceBuilder(context, aitHandlers);

    var _pbProject = PBProject.fromJson(project.toJson());
    context.project = _pbProject;

    _pbProject.projectAbsPath =
        p.join(MainInfo().outputPath, MainInfo().projectName);

    _pbProject.forest = await Future.wait(_pbProject.forest
        .map((tree) => aitServiceBuilder.build(tree: tree))
        .toList());
    _pbProject.forest.removeWhere((element) => element == null);

    // TODO: do this in just one go
    await PBPrototypeAggregationService().linkDanglingPrototypeNodes();

    return _pbProject;
  }
}

class AITServiceBuilder {
  Logger log;

  PBIntermediateTree _intermediateTree;
  set intermediateTree(PBIntermediateTree tree) => _intermediateTree = tree;

  final PBContext _context;
  Stopwatch _stopwatch;

  /// These are the [AITHandler]s that are going to be transforming
  /// the [_intermediateTree] in a [Tuple2]. The [Tuple2.item1] is the id, if any, and
  /// [Tuple2.item2] is the actual [AITHandler]
  final List<Tuple2> _transformations = [];

  AITServiceBuilder(this._context,
      [List transformations, PBIntermediateTree tree]) {
    log = Logger(runtimeType.toString());
    _stopwatch = Stopwatch();
    _intermediateTree = tree;

    if (transformations != null) {
      transformations.forEach(addTransformation);
      if (_verifyTransformationsFailed()) {
        throw Error();
      }
    }
  }

  /// Adding a [transformation] that will be applyed to the [PBIntermediateTree]. The [id]
  /// is to [log] the [transformation].
  AITServiceBuilder addTransformation(transformation, {String id}) {
    id ??= transformation.runtimeType.toString();
    if (transformation is AITHandler) {
      _transformations.add(Tuple2(id, transformation.handleTree));
    } else if (transformation is AITNodeTransformation) {
      _transformations.add(Tuple2(id, transformation));
    }
    return this;
  }

  /// Verifies that only the allows data types are within the [_transformations]
  bool _verifyTransformationsFailed() {
    return _transformations.any((transformation) =>
        transformation.item2 is! AITHandler &&
        transformation.item2 is! AITNodeTransformation &&
        transformation.item2 is! AITTransformation);
  }

  Future<PBIntermediateTree> build({PBIntermediateTree tree}) async {
    if (_intermediateTree == null && tree == null) {
      throw NullThrownError();
    }
    _intermediateTree ??= tree;

    var treeName = _intermediateTree.name;
    log.fine('Transforming $treeName ...');

    for (var transformationTuple in _transformations) {
      var transformation = transformationTuple.item2;
      var name = transformationTuple.item1;

      _stopwatch.start();
      log.debug('Started running $name...');
      try {
        if (transformation is AITNodeTransformation) {
          for (var node in _intermediateTree) {
            node = await transformation(_context, node);
          }
        } else if (transformation is AITTransformation) {
          _intermediateTree = await transformation(_context, _intermediateTree);
        }

        if (_intermediateTree == null || _intermediateTree.rootNode == null) {
          log.error(
              'The $name returned a null \"$treeName\" $PBIntermediateTree (or its rootnode is null)\n after its transformation, this will remove the tree from the process!');
          throw NullThrownError();
        }
      } catch (e) {
        MainInfo().captureException(e);
        log.error('${e.toString()} at $name');
      } finally {
        _stopwatch.stop();
        log.debug(
            'Stoped running $name (${_stopwatch.elapsed.inMilliseconds})');
      }
    }
    log.fine('Finish transforming $treeName');
    return _intermediateTree;
  }
}

/// Abstract class for Generatiion Services
/// so they all have the current context
abstract class AITHandler {
  Logger logger;

  /// Delegates the tranformation/modification to the current [AITHandler]
  Future<PBIntermediateTree> handleTree(
      PBContext context, PBIntermediateTree tree);
  AITHandler() {
    logger = Logger(runtimeType.toString());
  }
}

typedef AITTransformation = Future<PBIntermediateTree> Function(
    PBContext, PBIntermediateTree);
typedef AITNodeTransformation = Future<PBIntermediateNode> Function(
    PBContext, PBIntermediateNode);
