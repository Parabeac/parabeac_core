import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_center.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_positioned.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/row.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

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
  void setConstraints(PBContext context, T node) {
    if (context.contextConstraints.fixedHeight) {
      node.constraints?.fixedHeight = context.contextConstraints?.fixedHeight;
      node.constraints?.pinTop = true;
      node.constraints?.pinBottom = false;
    }

    if (context.contextConstraints.fixedWidth) {
      node.constraints?.fixedWidth = context.contextConstraints.fixedWidth;
      node.constraints?.pinLeft = true;
      node.constraints?.pinRight = false;
    }

    if (node.constraints.fixedHeight) {
      context.contextConstraints.fixedHeight = true;
    }
    if (node.constraints.fixedWidth) {
      context.contextConstraints.fixedWidth = true;
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
    context.tree.addEdges(padding, [child]);
    context.tree.addEdges(node, [padding]);

    // super.setConstraints(context, node);
  }
}

class NoAlignment extends AlignStrategy {
  @override
  void align(PBContext context, PBIntermediateNode node) {
    // super.setConstraints(context, node);
  }
}

class PositionedAlignment extends AlignStrategy<PBIntermediateStackLayout> {
  /// Do we need to subtract some sort of offset? Maybe child .frame.topLeft.x - topLeftCorner.x?

  @override
  void align(PBContext context, PBIntermediateStackLayout node) {
    var alignedChildren = <PBIntermediateNode>[];
    var tree = context.tree;
    var nodeChildren = context.tree.childrenOf(node);

    nodeChildren.forEach((child) {
      var centerY = false;
      var centerX = false;

      var heightLayoutSizing = ParentLayoutSizing.INHERIT;
      var widthLayoutSizing = ParentLayoutSizing.INHERIT;

      var parentLayout = _findNearestParentLayout(node);

      /// Assign proper axis sizing for checking constraint replacements

      if (parentLayout != null && parentLayout is PBIntermediateColumnLayout) {
        heightLayoutSizing = node.layoutMainAxisSizing;
        widthLayoutSizing = node.layoutCrossAxisSizing;
      } else if (parentLayout != null &&
          parentLayout is PBIntermediateRowLayout) {
        heightLayoutSizing = node.layoutCrossAxisSizing;
        widthLayoutSizing = node.layoutMainAxisSizing;
      }

      /// Rule to inherit fixed height to children
      if (node.constraints.fixedHeight &&
          heightLayoutSizing != ParentLayoutSizing.STRETCH) {
        child.constraints.fixedHeight = true;
        if (!child.constraints.pinTop && !child.constraints.pinBottom) {
          child.constraints.pinTop = true;
          child.constraints.pinBottom = false;
        }
      }

      /// Rule to inherit fixed width to children
      if (node.constraints.fixedWidth &&
          widthLayoutSizing != ParentLayoutSizing.STRETCH) {
        child.constraints.fixedWidth = true;
        if (!child.constraints.pinLeft && !child.constraints.pinRight) {
          child.constraints.pinLeft = true;
          child.constraints.pinRight = false;
        }
      }

      var injectedPositioned = InjectedPositioned(
        child.name,
        null,
        child.frame,
        constraints: child.constraints.copyWith(),
        valueHolder: PositionedValueHolder(
            top: child.frame.topLeft.y - node.frame.topLeft.y,
            bottom: node.frame.bottomRight.y - child.frame.bottomRight.y,
            left: child.frame.topLeft.x - node.frame.topLeft.x,
            right: node.frame.bottomRight.x - child.frame.bottomRight.x,
            width: child.frame.width,
            height: child.frame.height),
      );

      /// Rules to center child horizontally
      if ((!child.constraints.pinLeft && !child.constraints.pinRight) &&
          child.constraints.fixedWidth) {
        if (widthLayoutSizing == ParentLayoutSizing.STRETCH) {
          injectedPositioned.constraints.fixedWidth = true;
        } else if (widthLayoutSizing == ParentLayoutSizing.INHERIT) {
          injectedPositioned.constraints.fixedWidth = false;
        }
        centerX = true;
      }

      /// Rules to center child vertically
      if ((!child.constraints.pinTop && !child.constraints.pinBottom) &&
          child.constraints.fixedHeight) {
        if (heightLayoutSizing == ParentLayoutSizing.STRETCH) {
          injectedPositioned.constraints.fixedHeight = true;
        } else if (heightLayoutSizing == ParentLayoutSizing.INHERIT) {
          injectedPositioned.constraints.fixedHeight = false;
        }
        centerY = true;
      }

      alignedChildren.add(injectedPositioned);
      if (!(centerX || centerY)) {
        /// we are no center, since there is no need in either axis
        tree.addEdges(injectedPositioned, [child]);
      } else {
        // Center widget to wrap child
        var center = InjectedCenter(null, child.frame.boundingBox(child.frame),
            '$InjectedCenter-${child.name}');
        if (child is! PBContainer) {
          /// The container is going to be used to control the point value height/width
          var container = InjectedContainer(
            null,
            child.frame.boundingBox(child.frame),
            name: child.name,
            constraints: child.constraints.copyWith(),
          );
          tree.addEdges(container, [child]);
          tree.addEdges(center, [container]);
          tree.addEdges(injectedPositioned, [center]);
        } else {
          tree.addEdges(center, [child]);
          tree.addEdges(injectedPositioned, [center]);
        }
      }
    });
    tree.replaceChildrenOf(node, alignedChildren);
    // super.setConstraints(context, node);
  }

  /// Traverses [node] upwards and returns the first [PBLayoutIntermediateNode].
  ///
  /// Returns [null] if there is none.
  PBLayoutIntermediateNode _findNearestParentLayout(PBIntermediateNode node) {
    //TODO: We could abstract this method to [PBIntermediateTree] to look for any type of node up the tree using generics.
    if (node == null) {
      return null;
    }
    var iter = node.parent;

    /// Go up the tree in search of a [PBLayoutIntermediateNode]
    while (iter != null) {
      if (iter is PBLayoutIntermediateNode) {
        return iter;
      }
      iter = iter.parent;
    }

    return null;
  }
}
