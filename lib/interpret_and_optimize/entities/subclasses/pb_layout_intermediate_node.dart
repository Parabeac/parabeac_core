import 'dart:math';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/layout_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

/// This represents a node that should be a Layout; it contains a set of children arranged in a specific manner. It is also responsible for understanding its main axis spacing, and crossAxisAlignment.
/// Superclass: PBIntermediateNode
abstract class PBLayoutIntermediateNode extends PBIntermediateNode
    implements PBInjectedIntermediate {
  /// LayoutNodes support 0 or multiple children.
  List _children = [];

  ///Getting the children
  List<PBIntermediateNode> get children => List.from(_children);

  ///The rules of the layout. MAKE SURE TO REGISTER THEIR CUSTOM RULES
  List<LayoutRule> _layoutRules = [];

  ///Getting the rules of the layout
  List<LayoutRule> get rules => List.from(_layoutRules);

  ///Exceptions to the rules of the layout. MAKE SURE TO REGISTER THEIR CUSTOM EXCEPTIONS
  List<LayoutException> _exceptions = [];

  ///Getting the exceptions of the rules.
  List<LayoutException> get exceptions => List.from(_exceptions);

  PrototypeNode prototypeNode;

  ///
  PBLayoutIntermediateNode(this._layoutRules, this._exceptions,
      PBContext currentContext, String name,
      {topLeftCorner, bottomRightCorner, UUID, this.prototypeNode})
      : super(topLeftCorner, bottomRightCorner, UUID, name,
            currentContext: currentContext);

  void alignChildren();

  ///Replace the current children with the [children]
  void replaceChildren(List<PBIntermediateNode> children) {
    if (children != null && children.isNotEmpty) {
      _children = children;
      _children.removeWhere((element) =>
          element.topLeftCorner == null || element.bottomRightCorner == null);
      _resize();
    }
  }

  /// Replace the child at `index` for `replacement`.
  /// Returns true if the replacement wsa succesful, false otherwise.
  bool replaceChildAt(int index, PBIntermediateNode replacement) {
    if (_children != null && _children.length > index) {
      _children[index] = replacement;
      return true;
    }
    return false;
  }

  ///Add node to child
  void addChildToLayout(PBIntermediateNode node) {
    _children.add(node);
    _resize();
  }

  void _resize() {
    assert(_children.isNotEmpty,
        'There should be children in the layout so it can resize.');
    var minX = (_children[0] as PBIntermediateNode).topLeftCorner.x,
        minY = (_children[0] as PBIntermediateNode).topLeftCorner.y,
        maxX = (_children[0] as PBIntermediateNode).bottomRightCorner.x,
        maxY = (_children[0] as PBIntermediateNode).bottomRightCorner.y;
    for (var child in _children) {
      minX = min((child as PBIntermediateNode).topLeftCorner.x, minX);
      minY = min((child as PBIntermediateNode).topLeftCorner.y, minY);
      maxX = max((child as PBIntermediateNode).bottomRightCorner.x, maxX);
      maxY = max((child as PBIntermediateNode).bottomRightCorner.y, maxY);
    }
    topLeftCorner = Point(minX, minY);
    bottomRightCorner = Point(maxX, maxY);
  }

  ///Remove Child
  bool removeChildren(PBIntermediateNode node) {
    if (_children.contains(node)) {
      _children.remove(node);
    }
    _resize();
    return false;
  }

  ///Sort children
  void sortChildren() => _children.sort(
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
