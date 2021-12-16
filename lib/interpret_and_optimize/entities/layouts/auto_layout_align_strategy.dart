import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/layout_properties.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/row.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

import '../injected_sized_box.dart';

class AutoLayoutAlignStrategy extends AlignStrategy<PBLayoutIntermediateNode> {
  @override
  void align(PBContext context, node) {
    if (node is PBIntermediateColumnLayout) {
      if (needsSpacing(node)) {
        _insertBoxes(context, node, true);
      }
    } else if (node is PBIntermediateRowLayout) {
      if (needsSpacing(node)) {
        _insertBoxes(context, node, false);
      }
    }
  }

  bool needsSpacing(node) =>
      node.layoutProperties.spacing != null &&
      node.layoutProperties.primaryAxisAlignment !=
          IntermediateAxisAlignment.SPACE_BETWEEN;

  void _insertBoxes(PBContext context, node, bool isVertical) {
    var children = context.tree.childrenOf(node);

    var newChildren =
        _addBoxes(children, isVertical, node.layoutProperties.spacing);

    context.tree.replaceChildrenOf(node, newChildren);
  }

  List<PBIntermediateNode> _addBoxes(
      List<PBIntermediateNode> children, bool isVertical, num space) {
    var spacedChildren = <PBIntermediateNode>[];

    for (var i = 0; i < children.length; i++) {
      var child = children[i];

      /// Do not add spacing for first and last child.
      /// This is not allowed
      if (i > 0 && i < children.length) {
        var tHeight = isVertical ? space : null;
        var tWidth = isVertical ? null : space;

        /// Creating sized box
        var newBox = IntermediateSizedBox(
          height: tHeight,
          width: tWidth,

          /// Calculating the Frame properties based
          /// on the current and previous children's frame
          frame: child.frame.copyWith(
            left: isVertical
                ? 0
                : children[i - 1].frame.left + children[i - 1].frame.width,
            top: isVertical
                ? children[i - 1].frame.top + children[i - 1].frame.height
                : 0,
            height: tHeight,
            width: tWidth,
            z: 1,
          ),
        );

        /// Add Spacer
        spacedChildren.add(newBox);
      }

      /// Add new child
      spacedChildren.add(child);
    }

    return spacedChildren;
  }
}
