import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/row.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pbdl_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_generation_service.dart';

///tree.where((element) => element != null).toList().reversed.map((e) => e.name).toList()
class PBConstraintGenerationService implements AITService {
  @override
  PBContext currentContext;

  PBConstraintGenerationService();

  /// Traverse to the bottom of the tree, and implement constraints to nodes that don't already contain it such as [InjectedContainer] and then work our way up the tree.
  /// Through Traversal, discover whether there are elements that will conflict on scaling, if so, change the layout to a Stack.
  Future<PBIntermediateTree> implementConstraints(PBIntermediateTree tree, PBContext context) {
    currentContext = context;
    if (tree.rootNode == null) {
      return Future.value(tree);
    }

    for (var node
        in tree.where((element) => element != null).toList().reversed) {
      if (node is PBLayoutIntermediateNode) {
        // if (node.children.isNotEmpty) {
        /// Inherit Constraints from all the children of this layout.
        node.children
            .where((element) => element != null)
            .toList()
            .forEach((element) {
          node.constraints = _inheritConstraintsFromChild(
              constraints: node.constraints ??
                  PBIntermediateConstraints(
                    pinTop: false,
                    pinBottom: false,
                    pinLeft: false,
                    pinRight: false,
                  ),
              childConstraints: element.constraints);
        });
        if (node is PBLayoutIntermediateNode) {
          if (_shouldLayoutBeStack(node)) {
            /// Change Layout to Stack
            var newStackReplacement =
                PBIntermediateStackLayout(node.UUID, node.name);
            node.attributes.forEach((element) {
              newStackReplacement.addAttribute(element);
            });
            newStackReplacement.constraints = node.constraints;
            node = newStackReplacement;
          }
        }
      }
      if (node.constraints == null) {
        if (node.child?.constraints == null) {
          // if (node.child != null) {
          print(
              "Constraint Inheritance could not be performed because child's constraints were null for class type: [${node.runtimeType}]");
          // }
          if (node is! InheritedText) {
            print('asdf');
          } else {
            node.constraints = PBIntermediateConstraints();
          }
        } else {
          node.constraints = node.child.constraints;
        }
      }
    }
    return Future.value(tree);
  }

  /// Go through children and find out if there's a node that will overlap another node when scaling.
  bool _shouldLayoutBeStack(PBLayoutIntermediateNode node) {
    if (node is PBIntermediateStackLayout) {
      return false;
    } else if (node is PBIntermediateColumnLayout) {
      var res = _isVerticalOverlap(node);
      print(res);
      return res;
    } else if (node is PBIntermediateRowLayout) {
      var res = _isHorizontalOverlap(node);
      print(res);
      return res;
    } else {
      print(
          'This constraint generation service does not support this layout: ${node.runtimeType}');
      return false;
    }
  }

  bool _isHorizontalOverlap(PBLayoutIntermediateNode node) {
    var lastLeftPinIndex = -1;
    var lastRightPinIndex = -1;
    var isOverlap = false;
    node.children.asMap().forEach((key, value) {
      if (value.constraints.pinLeft) {
        if (key - 1 != lastLeftPinIndex) {
          isOverlap = true;
        } else {
          lastLeftPinIndex = key;
        }
      }
    });

    if (isOverlap) {
      return isOverlap;
    }

    node.children.reversed.toList().asMap().forEach((key, value) {
      /// Needs to be reversed.
      if (value.constraints.pinRight) {
        if (key - 1 != lastRightPinIndex) {
          isOverlap = true;
        } else {
          lastRightPinIndex = key;
        }
      }
    });
    return isOverlap;
  }

  bool _isVerticalOverlap(PBLayoutIntermediateNode node) {
    var lastTopPinIndex = -1;
    var lastBottomPinIndex = -1;
    var isOverlap = false;
    node.children.asMap().forEach((key, value) {
      if (value.constraints.pinTop) {
        if (key - 1 != lastTopPinIndex) {
          isOverlap = true;
        } else {
          lastTopPinIndex = key;
        }
      }
    });

    if (isOverlap) {
      return isOverlap;
    }

    node.children.reversed.toList().asMap().forEach((key, value) {
      if (value.constraints.pinBottom) {
        if (key - 1 != lastBottomPinIndex) {
          isOverlap = true;
        } else {
          lastBottomPinIndex = key;
        }
      }
    });
    return isOverlap;
  }

  PBIntermediateConstraints _inheritConstraintsFromChild(
      {PBIntermediateConstraints constraints,
      PBIntermediateConstraints childConstraints}) {
    if (childConstraints.pinLeft) {
      constraints.pinLeft = true;
    }
    if (childConstraints.pinRight) {
      constraints.pinRight = true;
    }
    if (childConstraints.pinTop) {
      constraints.pinTop = true;
    }
    if (childConstraints.pinBottom) {
      constraints.pinBottom = true;
    }
    if (childConstraints.fixedHeight != null) {
      if (constraints.fixedHeight == null) {
        constraints.fixedHeight = childConstraints.fixedHeight;
      } else if (constraints.fixedHeight < childConstraints.fixedHeight) {
        constraints.fixedHeight = childConstraints.fixedHeight;
      }
    }
    if (childConstraints.fixedWidth != null) {
      if (constraints.fixedWidth == null) {
        constraints.fixedWidth = childConstraints.fixedWidth;
      } else if (constraints.fixedWidth < childConstraints.fixedWidth) {
        constraints.fixedWidth = childConstraints.fixedWidth;
      }
    }
    return constraints;
  }
}
