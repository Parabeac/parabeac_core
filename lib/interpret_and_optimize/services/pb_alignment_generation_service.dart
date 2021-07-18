import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/layer_tuple.dart';
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
    currentContext = context;
    var originalRoot = tree.rootNode;
    if (originalRoot == null) {
      log.warning(
          '[PBAlignmentGenerationService] generate() attempted to generate a non-existing tree');
      return null;
    }

    var queue = <LayerTuple>[];
    queue.add(LayerTuple([originalRoot], null));
    while (queue.isNotEmpty) {
      var currentLayer = queue.removeAt(0);

      for (var currentIntermediateNode in currentLayer.nodeLayer) {
        if (currentIntermediateNode is PBVisualIntermediateNode) {
          currentIntermediateNode.alignChild();
        } else if (currentIntermediateNode is PBLayoutIntermediateNode) {
          currentIntermediateNode.alignChildren();
        }
        if (currentIntermediateNode == null) {
          continue;
        }

        currentIntermediateNode.attributes.forEach((attribute) {
          attribute.attributeNodes.forEach((node) {
            queue.add(LayerTuple([node], currentIntermediateNode));
          });
        });
      }
    }
    tree.rootNode = originalRoot;
    return Future.value(tree);
  }

  @override
  PBContext currentContext;

  @override
  Future<PBIntermediateTree> handleTree(PBContext context, PBIntermediateTree tree) {
    return addAlignmentToLayouts(tree, context);
  }
}
