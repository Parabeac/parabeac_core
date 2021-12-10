import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
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
      if (node.layoutProperties.spacing != null) {
        _insertBoxes(context, node, true);
      }
    } else if (node is PBIntermediateRowLayout) {
      if (node.layoutProperties.spacing != null) {
        _insertBoxes(context, node, false);
      }
    }

    print('Fabi');
  }

  void _insertBoxes(PBContext context, node, bool isVertical) {
    var children = context.tree.childrenOf(node);

    var newChildren =
        _addBoxes(children, isVertical, node.layoutProperties.spacing);

    context.tree.replaceChildrenOf(node, newChildren);
  }

  List<PBIntermediateNode> _addBoxes(
      List<PBIntermediateNode> children, bool isVertical, num space) {
    var boxSpace = 1;
    var length = children.length - 1;
    for (var i = 0; i < length; i++) {
      var newBox = PBSizedBox(
        height: isVertical ? space : null,
        width: isVertical ? null : space,
      );
      children.insert(boxSpace, newBox);
      boxSpace += 2;
    }
    return children;
  }
}
