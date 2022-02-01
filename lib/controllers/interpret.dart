import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_linker_service.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/group/base_group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/element_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_alignment_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_layout_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_symbol_linker_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/state_management_node_interpreter.dart';
import 'package:quick_log/quick_log.dart';
import 'package:sentry/sentry.dart';
import 'package:tuple/tuple.dart';

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
    StateManagementNodeInterpreter(),
    PBSymbolLinkerService(),
    // PBPluginControlService(),
    PBLayoutGenerationService(),
    // PBConstraintGenerationService(),
    PBAlignGenerationService(),
    PBPlatformOrientationLinkerService(),
  ];

  Future<PBIntermediateTree> interpretAndOptimize(
      PBIntermediateTree tree, PBContext context, PBProject project,
      {List<AITHandler> handlers, AITServiceBuilder aitServiceBuilder}) async {
    handlers ??= aitHandlers;

    aitServiceBuilder ??= AITServiceBuilder(aitHandlers);
    var elementStorage = ElementStorage();

    elementStorage.elementToTree[tree.rootNode.UUID] = tree.UUID;
    elementStorage.treeUUIDs[tree.UUID] = tree;

    /// This is a workaround for adding missing information to either the [PBContext] or any of the
    /// [PBIntermediateNode]s.
    aitServiceBuilder.addTransformation(
        (PBContext context, PBIntermediateNode node, PBIntermediateTree tree) {
      elementStorage.treeUUIDs[tree.UUID] = tree;
      elementStorage.elementToTree[node.UUID] = tree.UUID;
      return Future.value(node);
    }, index: 0, id: 'Indexing ${tree.name}').addTransformation(
        (PBContext context, PBIntermediateTree tree) async {
      //
      var baseGroupList = tree.whereType<BaseGroup>();

      baseGroupList.forEach((group) => tree.remove(group, keepChildren: true));

      return Future.value(tree);
    }, index: 1, id: 'Removing the $BaseGroup from ${tree.name}');

    // TODO: We should dynamically add the [PBPrototypeLinkerService] to `aitHandlers`
    // somewhere else so that it does not check the configuration every time
    // we process a tree
    if (MainInfo().configuration.enablePrototyping) {
      await _pbPrototypeLinkerService.linkPrototypeNodes(tree, context);
    }
    // await PBPrototypeAggregationService().linkDanglingPrototypeNodes();

    return aitServiceBuilder.build(tree: tree, context: context);
  }
}

class AITServiceBuilder {
  Logger log;

  PBIntermediateTree _intermediateTree;
  set intermediateTree(PBIntermediateTree tree) => _intermediateTree = tree;

  Stopwatch _stopwatch;

  /// These are the [AITHandler]s that are going to be transforming
  /// the [_intermediateTree] in a [Tuple2]. The [Tuple2.item1] is the id, if any, and
  /// [Tuple2.item2] is the actual [AITHandler]
  final List<Tuple2> _transformations = [];

  AITServiceBuilder([List transformations, PBIntermediateTree tree]) {
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
  AITServiceBuilder addTransformation(transformation, {String id, int index}) {
    id ??= transformation.runtimeType.toString();
    index ??= _transformations.length;
    if (transformation is AITHandler) {
      _transformations.insert(index, Tuple2(id, transformation.handleTree));
    } else if (transformation is AITNodeTransformation ||
        transformation is AITTransformation) {
      _transformations.insert(index, Tuple2(id, transformation));
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

  Future<PBIntermediateTree> build(
      {PBIntermediateTree tree, PBContext context}) async {
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
          for (var child in _intermediateTree) {
            var dVertex =
                await transformation(context, child, _intermediateTree);
            if (dVertex.UUID != child.UUID) {
              tree.replaceNode(child, dVertex);
            }
          }
        } else if (transformation is AITTransformation &&
            _intermediateTree != null) {
          _intermediateTree = await transformation(context, _intermediateTree);
        }

        if (_intermediateTree == null || _intermediateTree.rootNode == null) {
          log.warning(
              'The $name returned a null \"$treeName\" $PBIntermediateTree (or its rootnode is null)\n after its transformation, this will remove the tree from the process!');
          // throw NullThrownError();
        }
      } catch (e, stackTrace) {
        await Sentry.captureException(e, stackTrace: stackTrace);
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
    PBContext, PBIntermediateNode, PBIntermediateTree);
