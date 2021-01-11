import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import '../../pb_generation_manager.dart';
import '../middleware.dart';

class BLoCMiddleware extends Middleware {
  BLoCMiddleware(PBGenerationManager generationManager)
      : super(generationManager);

  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    if (node?.auxiliaryData?.stateGraph?.states?.isNotEmpty ?? false) {
      //TODO:
    }
    return node;
  }
}
