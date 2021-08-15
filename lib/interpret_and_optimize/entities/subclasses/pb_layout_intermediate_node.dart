import 'dart:math';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_prototype_enabled.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/layout_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:uuid/uuid.dart';

/// This represents a node that should be a Layout; it contains a set of children arranged in a specific manner. It is also responsible for understanding its main axis spacing, and crossAxisAlignment.
/// Superclass: PBIntermediateNode
abstract class PBLayoutIntermediateNode extends PBIntermediateNode
    implements PBInjectedIntermediate, PrototypeEnable {
  ///The rules of the layout. MAKE SURE TO REGISTER THEIR CUSTOM RULES
  final List<LayoutRule> _layoutRules;

  ///Getting the rules of the layout
  List<LayoutRule> get rules => List.from(_layoutRules);

  ///Exceptions to the rules of the layout. MAKE SURE TO REGISTER THEIR CUSTOM EXCEPTIONS
  final List<LayoutException> _exceptions;

  ///Getting the exceptions of the rules.
  List<LayoutException> get exceptions => List.from(_exceptions);

  @override
  PrototypeNode prototypeNode;

  Map alignment = {};

  PBLayoutIntermediateNode(String UUID, Rectangle frame, this._layoutRules,
      this._exceptions, String name,
      {this.prototypeNode, PBIntermediateConstraints constraints})
      : super(UUID ?? Uuid().v4(), frame, name, constraints: constraints) {
    childrenStrategy = MultipleChildStrategy('children');
  }

  ///Replace the current children with the [children]
  // void replaceChildren(List<PBIntermediateNode> children, PBContext context) {
  //   if (children.isNotEmpty) {
  //     this.children = children;
  //     resize(context);
  //   } else {
  //     logger.warning(
  //         'Trying to add a list of children to the $runtimeType that is either null or empty');
  //   }
  // }

  // @override
  // void addChild(node){
  //   resize(context)
  //   super.addChild(node);
  // }

  /// Replace the child at `index` for `replacement`.
  /// Returns true if the replacement wsa succesful, false otherwise.
  // bool replaceChildAt(int index, PBIntermediateNode replacement) {
  //   if (children != null && children.length > index) {
  //     children[index] = replacement;
  //     return true;
  //   }
  //   return false;
  // }

  @override
  void handleChildren(PBContext context) {
    context.tree.addChildrenObeserver(UUID, (modification, children) {
      if (modification == CHILDREN_MOD.CREATED &&
          modification == CHILDREN_MOD.REMOVED) {
        resize(context, children);
      }
    });
    super.handleChildren(context);
  }

  void resize(PBContext context, [List<PBIntermediateNode> children]) {
    children =
        children ?? context.tree.edges(AITVertex(this)).map((e) => e.data);
    if (children.isEmpty) {
      logger
          .warning('There should be children in the layout so it can resize.');
      return;
    }
    // var minX = (children[0]).frame.topLeft.x,
    //     minY = (children[0]).frame.topLeft.y,
    //     maxX = (children[0]).frame.bottomRight.x,
    //     maxY = (children[0]).frame.bottomRight.y;
    // for (var child in children) {
    //   minX = min((child).frame.topLeft.x, minX);
    //   minY = min((child).frame.topLeft.y, minY);
    //   maxX = max((child).frame.bottomRight.x, maxX);
    //   maxY = max((child).frame.bottomRight.y, maxY);
    // }
    children.forEach((child) => frame = frame.boundingBox(child.frame));
    // frame = Rectangle.fromPoints(Point(minX, minY), Point(maxX, maxY));
  }

  ///Remove Child
  // bool removeChildren(PBIntermediateNode node, PBContext context) {
  //   if (children.contains(node)) {
  //     children.remove(node);
  //   }
  //   resize(context);
  //   return false;
  // }

  ///Sort children
  // void sortChildren() => children.sort(
  //     (child0, child1) => child0.frame.topLeft.compareTo(child1.frame.topLeft));

  ///The [PBLayoutIntermediateNode] contains a series of rules that determines if the children is part of that layout. All the children
  ///are going to have to meet the rules that the [PBLayoutIntermediateNode] presents. This method presents a way of comparing two children [PBIntermediateNode]
  ///the method is returning a boolean value that demonstrates if the two nodes satisfies the rules of the [PBLayoutIntermediateNode]. If
  ///a list of children need to be compared, use `allSatisfiesRules()`.
  bool satisfyRules(PBContext context, 
      PBIntermediateNode currentNode, PBIntermediateNode nextNode) {
    ///First check if there is an exception then check that is satisfies all the rules.
    for (var exception in _exceptions) {
      if (exception.testException(currentNode, nextNode)) {
        return true;
      }
    }
    for (var rule in _layoutRules) {
      if (!rule.testRule(context, currentNode, nextNode)) {
        return false;
      }
    }
    return true;
  }

  ///NOTE: make sure that the children that are going to be added satisfy the reles of the [PBLayoutIntermediateNode]
  PBLayoutIntermediateNode generateLayout(
      List<PBIntermediateNode> children, PBContext currentContext, String name);

  void checkCrossAxisAlignment() {
    // if (attributes.first.attributeNode != null) {
    //   var attributesTopLeft = attributes.first.attributeNode.frame.topLeft;

    //   var attributesBottomRight =
    //       attributes.last.attributeNode.frame.bottomRight;

    //   var leftDifference = (frame.topLeft.x - attributesTopLeft.x).abs();

    //   var rightDifference =
    //       (frame.bottomRight.x - attributesBottomRight.x).abs();

    //   var topDifference = (frame.topLeft.y - attributesTopLeft.y).abs();

    //   var bottomDifference =
    //       (frame.bottomRight.y - attributesBottomRight.y).abs();

    //   if (leftDifference < rightDifference) {
    //     alignment['mainAxisAlignment'] =
    //         'mainAxisAlignment: MainAxisAlignment.start,';
    //   } else if (leftDifference > rightDifference) {
    //     alignment['mainAxisAlignment'] =
    //         'mainAxisAlignment: MainAxisAlignment.end,';
    //   } else {
    //     alignment['mainAxisAlignment'] =
    //         'mainAxisAlignment: MainAxisAlignment.center,';
    //   }

    //   if (topDifference < bottomDifference) {
    //     alignment['crossAxisAlignment'] =
    //         'crossAxisAlignment: CrossAxisAlignment.start,';
    //   } else if (topDifference > bottomDifference) {
    //     alignment['crossAxisAlignment'] =
    //         'crossAxisAlignment: CrossAxisAlignment.end,';
    //   } else {
    //     alignment['crossAxisAlignment'] =
    //         'crossAxisAlignment: CrossAxisAlignment.center,';
    //   }
    // }
  }
}
