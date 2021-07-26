import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_generation_service.dart';
import 'package:quick_log/quick_log.dart';

/// PBAlignmentGenerationService:
/// Interpret the alignment relationship between a child node and a parent Visual or Layout Node. After interpretation, inject the proper alignment whether that’s Padding based or Flex-based.
/// Input: PBIntermediateNode Tree
/// Output: PBIntermediateNode Tree
class PBAlignGenerationService implements AITHandler {
  var log;

  /// Constructor for PBPluginGenerationService, must include the root SketchNode
  PBAlignGenerationService() {
    log = Logger(runtimeType.toString());
  }

  /// Should find all layout nodes
  Future<PBIntermediateTree> addAlignmentToLayouts(PBIntermediateTree tree, PBContext context) {
    var originalRoot = tree.rootNode;
    if (originalRoot == null) {
      log.warning(
          '[PBAlignmentGenerationService] generate() attempted to generate a non-existing tree');
      return null;
    }

    tree.forEach((node) => node.align(context));
    return Future.value(tree);
  }

  @override
  Future<PBIntermediateTree> handleTree(PBContext context, PBIntermediateTree tree) {
    return addAlignmentToLayouts(tree, context);
  }
}
