import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_variation.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_vertex.dart';

class IntermediateState {
  IntermediateVariation variation;
  List<IntermediateVertex> vertexes;
  bool isAppState;

  /// Context is added in order for state to know how to generate
  /// and inspect `variation's` children.
  PBContext context;

  IntermediateState({
    this.variation,
    this.vertexes,
    this.isAppState,
    this.context,
  });
}
