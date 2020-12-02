import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

abstract class StateManagementConfig {
  /// This method should be called when a PBIntermediateNode contains other states.
  /// The method's responsibility is to communicate to the configurated state management system & return the state call code.
  String setStatefulNode(PBIntermediateNode node, PBGenerationManager manager);
}
