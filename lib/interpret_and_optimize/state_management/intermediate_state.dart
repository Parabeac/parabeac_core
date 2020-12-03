import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_variation.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_vertex.dart';

class IntermediateState {
  IntermediateVariation variation;
  List<IntermediateVertex> vertexes;
  bool isAppState;

  IntermediateState({
    this.variation,
    this.vertexes,
    this.isAppState,
  });
}
