import 'package:parabeac_core/interpret_and_optimize/state_management/directed_state_graph.dart';

class IntermediateAuxillaryData {
  DirectedStateGraph stateGraph;

  /// Info relating to a elements borders, currently just in a map format.
  Map borderInfo = {};

  /// Info relating to the alignment of an element, currently just in a map format.
  Map alignment = {};

  /// The background color of the element.
  String color = '';
}
