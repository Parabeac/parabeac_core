import 'package:parabeac_core/interpret_and_optimize/entities/alignments/expanded.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/layout_properties.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/row.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

import '../injected_sized_box.dart';

class AutoLayoutAlignStrategy extends AlignStrategy<PBLayoutIntermediateNode> {
  @override
  void align(PBContext context, node) {
    // TODO: Look for a way to not have to check if it is a col or row

    // New children list
    var spacedChildren = <PBIntermediateNode>[];
    var children = context.tree.childrenOf(node);
    sortChildren(children);
    var isVertical = true;
    num space;

    // Add boxes if necessary for Column
    if (node is PBIntermediateColumnLayout) {
      isVertical = true;
      space = node.layoutProperties.spacing;
    }
    // Add boxes if necessary for Row
    else if (node is PBIntermediateRowLayout) {
      isVertical = false;
      space = node.layoutProperties.spacing;
    }

    for (var i = 0; i < children.length; i++) {
      var child = children[i];

      /// Do not add spacing for first and last child.
      /// This is not allowed
      if (needsSpacing(node) && i > 0 && i < children.length) {
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

      var newChild = _needsContainer(child, isVertical, context);

      /// Add new child
      /// and _handleLayoutChild removes the crossAxisSizing of children
      /// in case the parent is fill on the cross axis
      spacedChildren.add(_handleLayoutChild(newChild, isVertical, context));
    }

    context.tree.replaceChildrenOf(node, spacedChildren);
  }

  ///Sort children
  void sortChildren(List<PBIntermediateNode> children) => children.sort(
      (child0, child1) => child0.frame.topLeft.compareTo(child1.frame.topLeft));

  /// Checks if child is a [PBLayoutIntermediateNode]
  /// and adds a container on top of it
  PBIntermediateNode _needsContainer(
      PBIntermediateNode child, bool isVertical, PBContext context) {
    if (child is! PBContainer) {
      // Creates container
      var wrapper = InjectedContainer(
        null,
        child.frame,
        name: child.name,
        constraints: _getConstraints(child, isVertical),
      )
        ..layoutCrossAxisSizing = child.layoutCrossAxisSizing
        ..layoutMainAxisSizing = child.layoutMainAxisSizing;
      context.tree.addEdges(wrapper, [child]);
      return wrapper;
    }
    return child;
  }

  PBIntermediateConstraints _getConstraints(
      PBIntermediateNode node, bool isVertical) {
    PBIntermediateConstraints newConstraints = node.constraints.copyWith();
    if (node is InheritedBitmap) {
      if (isVertical) {
        if (!node.constraints.fixedHeight &&
            node.layoutMainAxisSizing != ParentLayoutSizing.STRETCH) {
          newConstraints.fixedHeight = true;
        }
        if (!node.constraints.fixedWidth &&
            node.layoutCrossAxisSizing != ParentLayoutSizing.STRETCH) {
          newConstraints.fixedWidth = true;
        }
      } else {
        if (!node.constraints.fixedHeight &&
            node.layoutCrossAxisSizing != ParentLayoutSizing.STRETCH) {
          newConstraints.fixedHeight = true;
        }
        if (!node.constraints.fixedWidth &&
            node.layoutMainAxisSizing != ParentLayoutSizing.STRETCH) {
          newConstraints.fixedWidth = true;
        }
      }
    }
    return newConstraints.copyWith();
  }

  // This boolean let us know if the layout needs boxes or not
  bool needsSpacing(node) =>
      node.layoutProperties.spacing != null &&
      node.layoutProperties.primaryAxisAlignment !=
          IntermediateAxisAlignment.SPACE_BETWEEN;

  PBIntermediateNode _handleLayoutChild(
      PBIntermediateNode child, bool isVertical, PBContext context) {
    // Cross axis sizing
    switch (child.layoutCrossAxisSizing) {
      case ParentLayoutSizing.STRETCH:
        if (isVertical && child is PBContainer) {
          child.showWidth = false;
        } else if (!isVertical && child is PBContainer) {
          child.showHeight = false;
        }
        break;
      default:
    }

    // Main axis sizing
    switch (child.layoutMainAxisSizing) {
      case ParentLayoutSizing.STRETCH:
        var wrapper = InjectedExpanded(
          null,
          child.frame,
          null,
        );
        context.tree.addEdges(wrapper, [child]);

        return wrapper;
        break;
      default:
    }

    return child;
  }
}
