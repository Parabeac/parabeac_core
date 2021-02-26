import 'dart:math';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/layout_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_attribute.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:uuid/uuid.dart';

/// This represents a node that should be a Layout; it contains a set of children arranged in a specific manner. It is also responsible for understanding its main axis spacing, and crossAxisAlignment.
/// Superclass: PBIntermediateNode
abstract class PBLayoutIntermediateNode extends PBIntermediateNode
    implements PBInjectedIntermediate {
  ///Getting the children
  List<PBIntermediateNode> get children =>
      getAttributeNamed('children')?.attributeNodes;

  ///The rules of the layout. MAKE SURE TO REGISTER THEIR CUSTOM RULES
  List<LayoutRule> _layoutRules = [];

  ///Getting the rules of the layout
  List<LayoutRule> get rules => List.from(_layoutRules);

  ///Exceptions to the rules of the layout. MAKE SURE TO REGISTER THEIR CUSTOM EXCEPTIONS
  List<LayoutException> _exceptions = [];

  ///Getting the exceptions of the rules.
  List<LayoutException> get exceptions => List.from(_exceptions);

  PrototypeNode prototypeNode;

  PBLayoutIntermediateNode(this._layoutRules, this._exceptions,
      PBContext currentContext, String name,
      {topLeftCorner, bottomRightCorner, this.prototypeNode})
      : super(topLeftCorner, bottomRightCorner, Uuid().v4(), name,
            currentContext: currentContext) {
    // Declaring children for layout node
    addAttribute(PBAttribute('children'));
  }

  void alignChildren();

  ///Replace the current children with the [children]
  void replaceChildren(List<PBIntermediateNode> children) {
    if (children.isNotEmpty) {
      getAttributeNamed('children')?.attributeNodes = children;
      _resize();
    } else {
      PBIntermediateNode.logger.warning(
          'Trying to add a list of children to the $runtimeType that is either null or empty');
    }
  }

  /// Replace the child at `index` for `replacement`.
  /// Returns true if the replacement wsa succesful, false otherwise.
  bool replaceChildAt(int index, PBIntermediateNode replacement) {
    if (children != null && children.length > index) {
      getAttributeNamed('children').attributeNodes[index] = replacement;
      return true;
    }
    return false;
  }

  ///Add node to child
  void addChildToLayout(PBIntermediateNode node) {
    getAttributeNamed('children').attributeNodes.add(node);
    _resize();
  }

  void _resize() {
    if (children.isEmpty) {
      PBIntermediateNode.logger
          .warning('There should be children in the layout so it can resize.');
      return;
    }
    var minX = (children[0]).topLeftCorner.x,
        minY = (children[0]).topLeftCorner.y,
        maxX = (children[0]).bottomRightCorner.x,
        maxY = (children[0]).bottomRightCorner.y;
    for (var child in children) {
      minX = min((child).topLeftCorner.x, minX);
      minY = min((child).topLeftCorner.y, minY);
      maxX = max((child).bottomRightCorner.x, maxX);
      maxY = max((child).bottomRightCorner.y, maxY);
    }
    topLeftCorner = Point(minX, minY);
    bottomRightCorner = Point(maxX, maxY);
  }

  ///Remove Child
  bool removeChildren(PBIntermediateNode node) {
    if (children.contains(node)) {
      children.remove(node);
    }
    _resize();
    return false;
  }

  ///Sort children
  void sortChildren() => children.sort(
      (child0, child1) => child0.topLeftCorner.compareTo(child1.topLeftCorner));

  ///The [PBLayoutIntermediateNode] contains a series of rules that determines if the children is part of that layout. All the children
  ///are going to have to meet the rules that the [PBLayoutIntermediateNode] presents. This method presents a way of comparing two children [PBIntermediateNode]
  ///the method is returning a boolean value that demonstrates if the two nodes satisfies the rules of the [PBLayoutIntermediateNode]. If
  ///a list of children need to be compared, use `allSatisfiesRules()`.
  bool satisfyRules(
      PBIntermediateNode currentNode, PBIntermediateNode nextNode) {
    ///First check if there is an exception then check that is satisfies all the rules.
    for (var exception in _exceptions) {
      if (exception.testException(currentNode, nextNode)) {
        return true;
      }
    }
    for (var rule in _layoutRules) {
      if (!rule.testRule(currentNode, nextNode)) {
        return false;
      }
    }
    return true;
  }

  ///NOTE: make sure that the children that are going to be added satisfy the reles of the [PBLayoutIntermediateNode]
  PBLayoutIntermediateNode generateLayout(
      List<PBIntermediateNode> children, PBContext currentContext, String name);
}
