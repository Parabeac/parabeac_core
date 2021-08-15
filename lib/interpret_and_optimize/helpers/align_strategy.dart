import 'package:directed_graph/directed_graph.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_positioned.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:uuid/uuid.dart';

/// [AlignStrategy] uses the strategy pattern to define the alignment logic for
/// the [PBIntermediateNode].
abstract class AlignStrategy<T extends PBIntermediateNode> {
  void align(PBContext context, T node);

  /// Some aspects of the [PBContext] are going to be inherited to a subtree
  /// of the [PBIntermediateTree]. These are the [PBContext.fixedHeight] and
  /// [PBContext.fixedWidth].
  ///
  /// If the [context] contains either [context.fixedHeight] or [context.fixedHeight],
  /// then its going to force those values into the [node]. However, if the [node] contains non-null
  /// constrains and the [context] does not, then [context] is going to grab those values and force upon the children
  /// from that subtree.
  ///
  /// Another important note is when the [context] contains [context.fixedHeight] the subtree, then we will
  /// assign the [node.constraints.pinTop] = `true` and [node.constraints.pinBottom] = `false`.
  /// When [context.fixedWidth] is not `null`, se assign the [context.fixedWidth] to subtree and
  /// we make [node.constraints.pinLeft] = `true` and [node.constraints.pingRight] = `false`.
  void _setConstraints(PBContext context, T node) {
    context.contextConstraints.fixedHeight ??= node.constraints.fixedHeight;
    context.contextConstraints.fixedWidth ??= node.constraints.fixedWidth;

    if (context.contextConstraints.fixedHeight != null) {
      node.constraints.fixedHeight = context.contextConstraints.fixedHeight;
      node.constraints.pinTop = true;
      node.constraints.pinBottom = false;
    }

    if (context.contextConstraints.fixedWidth != null) {
      node.constraints.fixedWidth = context.contextConstraints.fixedWidth;
      node.constraints.pinLeft = true;
      node.constraints.pinRight = false;
    }
  }
}

class PaddingAlignment extends AlignStrategy {
  @override
  void align(PBContext context, PBIntermediateNode node) {
    var child = node.getAttributeNamed(context.tree, 'child');
    var padding = Padding(
      null,
      node.frame,
      child.constraints,
      left: (child.frame.topLeft.x - node.frame.topLeft.x).abs(),
      right: (node.frame.bottomRight.x - child.frame.bottomRight.x).abs(),
      top: (child.frame.topLeft.y - node.frame.topLeft.y).abs(),
      bottom: (child.frame.bottomRight.y - node.frame.bottomRight.y).abs(),
    );
    context.tree.addEdges(Vertex(padding), [Vertex(child)]);
    context.tree.addEdges(Vertex(node), [Vertex(padding)]);

    super._setConstraints(context, node);
  }
}

class NoAlignment extends AlignStrategy {
  @override
  void align(PBContext context, PBIntermediateNode node) {
    super._setConstraints(context, node);
  }
}

class PositionedAlignment extends AlignStrategy<PBIntermediateStackLayout> {
  /// Do we need to subtract some sort of offset? Maybe child .frame.topLeft.x - topLeftCorner.x?

  @override
  void align(PBContext context, PBIntermediateStackLayout node) {
    var alignedChildren = <PBIntermediateNode>[];
    var tree = context.tree;
    var nodeChildren = context.tree.childrenOf(node);
    nodeChildren.skipWhile((att) {
      var child = att;

      /// if they are the same size then there is no need for adjusting.
      if (child.frame.topLeft == node.frame.topLeft &&
          child.frame.bottomRight == node.frame.bottomRight) {
        alignedChildren.add(child);
        return true;
      }
      return false;
    }).forEach((att) {
      var child = att;
      var injectedPositioned = InjectedPositioned(null, child.frame,
          constraints: child.constraints,
          valueHolder: PositionedValueHolder(
              top: child.frame.topLeft.y - node.frame.topLeft.y,
              bottom: node.frame.bottomRight.y - child.frame.bottomRight.y,
              left: child.frame.topLeft.x - node.frame.topLeft.x,
              right: node.frame.bottomRight.x - child.frame.bottomRight.x,
              width: child.frame.width,
              height: child.frame.height));
      alignedChildren.add(injectedPositioned);
      tree.addEdges(Vertex(injectedPositioned), [Vertex(child)]);
    });
    tree.replaceChildrenOf(node, [alignedChildren]);
    super._setConstraints(context, node);
  }
}
