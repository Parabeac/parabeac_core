import 'package:parabeac_core/design_logic/pb_style.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/directed_state_graph.dart';

class IntermediateAuxiliaryData {
  DirectedStateGraph stateGraph;

  /// Info relating to a elements borders, currently just in a map format.
  Map borderInfo;

  /// The background color of the element.
  String color;

  /// the style of the element (which can be overridden)
  PBStyle style;

  IntermediateAuxiliaryData({
    this.stateGraph,
    this.color,
  }) {
    stateGraph ??= DirectedStateGraph();
  }
}
