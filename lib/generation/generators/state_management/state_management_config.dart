import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

abstract class StateManagementConfig {
  /// This method should be called when a PBIntermediateNode contains other states.
  /// The method's responsibility is to communicate to the configured state management system and return the state call code.
  ///
  /// The [node]'s state graph will be iterated through to generate each variation
  /// with the helper of [manager]. The [path] should be an absolute path to
  /// the directory where [node] will be generated.
  String setStatefulNode(
    PBIntermediateNode node,
    PBGenerationManager manager,
    String path,
  );
}
