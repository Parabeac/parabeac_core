import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:quick_log/quick_log.dart';

/// Abstract class for Generatiion Services
/// so they all have the current context
abstract class AITService {
  PBContext currentContext;

  AITService({this.currentContext});
}

typedef AITTransformation = Future<PBIntermediateTree> Function(
    PBIntermediateTree, PBContext);
typedef AITNodeTransformation = Future<PBIntermediateNode> Function(PBIntermediateNode, PBContext);

class AITServiceBuilder {
  Logger log;

  PBIntermediateTree _intermediateTree;
  set intermediateTree(PBIntermediateTree tree) => _intermediateTree = tree;

  final PBContext _context;
  Stopwatch _stopwatch;

  /// These are the [AITService]s that are going to be transforming
  /// the [_intermediateTree].
  final List _transformations;

  AITServiceBuilder(this._context,
      [this._intermediateTree,this._transformations = const [],]) {
    log = Logger(runtimeType.toString());
    _stopwatch = Stopwatch();
  }

  AITServiceBuilder addTransformation(AITTransformation transformation) {
    if (transformation != null) {
      _transformations.add(transformation);
    }
    return this;
  } 

  Future<PBIntermediateTree> build() async {
    for (var transformation in _transformations) {
      var name = transformation.runtimeType.toString();
      _stopwatch.start();
      log.info('Started running $name...');
      try {
        if(transformation is AITNodeTransformation){
          for(var node in _intermediateTree){
            node = await transformation(node, _context);
          }
        }
        else{
          _intermediateTree = await transformation(_intermediateTree, _context);
        }
      } catch (e) {
        MainInfo().captureException(e);
        log.error(
            '${e.toString()} at $name');
      } finally {
        _stopwatch.stop();
        log.info('stoped running $name (${_stopwatch.elapsed.inSeconds} sec)');
      }
    }
    return _intermediateTree;
  }
}
