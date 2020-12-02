import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_state.dart';

class DirectedStateGraph {
  List<IntermediateState> states = [];

  void addState(IntermediateState state) => states.add(state);
  void removeState(String variationUuid) =>
      states.removeWhere((element) => element.variation.UUID == variationUuid);
}
