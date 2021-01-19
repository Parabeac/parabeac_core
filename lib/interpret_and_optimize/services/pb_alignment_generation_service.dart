import 'package:parabeac_core/generation/prototyping/pb_dest_holder.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/layer_tuple.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_generation_service.dart';
import 'package:quick_log/quick_log.dart';

import '../entities/alignments/injected_positioned.dart';

/// PBAlignmentGenerationService:
/// Interpret the alignment relationship between a child node and a parent Visual or Layout Node. After interpretation, inject the proper alignment whether that’s Padding based or Flex-based.
/// Input: PBIntermediateNode Tree
/// Output: PBIntermediateNode Tree
class PBAlignGenerationService implements PBGenerationService {
  /// The originalRoot intermediate node.
  PBIntermediateNode originalRoot;

  var log;

  /// Constructor for PBPluginGenerationService, must include the root SketchNode
  PBAlignGenerationService(this.originalRoot, {this.currentContext}) {
    log = Logger(runtimeType.toString());
  }

  /// Should find all layout nodes
  PBIntermediateNode addAlignmentToLayouts() {
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
        if (currentIntermediateNode is PBVisualIntermediateNode &&
            currentIntermediateNode.child != null &&
            currentIntermediateNode.child is PBVisualIntermediateNode) {
          currentIntermediateNode.alignChild();
        } else if (currentIntermediateNode is PBLayoutIntermediateNode) {
          currentIntermediateNode.alignChildren();
        }

        /// Add next depth layer to queue.
        if (currentIntermediateNode is InjectedPositioned ||
            currentIntermediateNode is PBDestHolder) {
          if (currentIntermediateNode.child.child == null) {
            continue;
          }
          // Skip Align
          queue.add(LayerTuple([currentIntermediateNode.child.child],
              currentIntermediateNode.child));
        } else if (currentIntermediateNode is PBVisualIntermediateNode) {
          if (currentIntermediateNode.child == null) {
            continue;
          }
          queue.add(LayerTuple(
              [currentIntermediateNode.child], currentIntermediateNode));
        } else if (currentIntermediateNode is PBLayoutIntermediateNode) {
          queue.add(LayerTuple(
              currentIntermediateNode.children?.cast<PBIntermediateNode>(),
              currentIntermediateNode));
        } else if (currentIntermediateNode
            is PBSharedInstanceIntermediateNode) {
          if (currentIntermediateNode.child == null) {
            continue;
          }
          queue.add(LayerTuple(
              [currentIntermediateNode.child], currentIntermediateNode));
          // Do not align Instance Nodes
//          continue;
        } else {
          log.warning(
              'We don\'t support class type ${currentIntermediateNode.runtimeType} for adding to the queue.');
        }
      }
    }
    return originalRoot;
  }

  @override
  PBContext currentContext;
}
