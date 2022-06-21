import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

/// PBAlignmentGenerationService:
/// Interpret the alignment relationship between a child node and a parent Visual or Layout Node. After interpretation, inject the proper alignment whether that’s Padding based or Flex-based.
/// Input: PBIntermediateNode Tree
/// Output: PBIntermediateNode Tree
class PBAlignGenerationService extends AITHandler {
  /// Constructor for PBPluginGenerationService, must include the root SketchNode
  PBAlignGenerationService();

  /// Should find all layout nodes
  Future<PBIntermediateTree> addAlignmentToLayouts(
      PBIntermediateTree tree, PBContext context) {
    if (tree.rootNode == null) {
      logger.warning(
          '[PBAlignmentGenerationService] generate() attempted to generate a non-existing tree');
      return null;
    }

    tree.rootNode.align(context);

    return Future.value(tree);
  }

  @override
  Future<PBIntermediateTree> handleTree(
      PBContext context, PBIntermediateTree tree) {
    return addAlignmentToLayouts(tree, context);
  }
}
