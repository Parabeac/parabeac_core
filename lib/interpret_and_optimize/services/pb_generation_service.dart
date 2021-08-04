import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:quick_log/quick_log.dart';

/// Abstract class for Generatiion Services
/// so they all have the current context
abstract class AITHandler {
  Logger logger;
  /// Delegates the tranformation/modification to the current [AITHandler]
  Future<PBIntermediateTree> handleTree(
      PBContext context, PBIntermediateTree tree);
  AITHandler(){
    logger = Logger(runtimeType.toString());
  }
}

typedef AITTransformation = Future<PBIntermediateTree> Function(
    PBContext, PBIntermediateTree);
typedef AITNodeTransformation = Future<PBIntermediateNode> Function(
    PBContext, PBIntermediateNode);

typedef PBDLConversion = Future<PBIntermediateTree> Function(
    DesignNode, PBContext);


