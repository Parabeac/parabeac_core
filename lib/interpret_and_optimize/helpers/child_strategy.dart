import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:quick_log/quick_log.dart';

abstract class ChildrenStrategy {
  Logger logger;
  final String attributeName;
  final bool overwridable;
  ChildrenStrategy(this.attributeName, this.overwridable) {
    logger = Logger(runtimeType.toString());
  }
  void addChild(PBIntermediateNode target, dynamic children,
      ChildrenMod<PBIntermediateNode> addChild, PBIntermediateTree tree);
}

class OneChildStrategy extends ChildrenStrategy {
  OneChildStrategy(String attributeName, [bool overridable = false])
      : super(attributeName, overridable);

  @override
  void addChild(PBIntermediateNode target, dynamic child,
      ChildrenMod<PBIntermediateNode> addChild, tree) {
    var candidate;
    var targetChildren = tree.childrenOf(target);

    if (child is Iterable && child.isNotEmpty) {
      if (child.length > 1) {
        logger.warning(
            'Only considering the first child of ${child.runtimeType.toString()} since it can only add one child to ${target.runtimeType.toString()}');
      }
      candidate = child.first;
    } else if (child is PBIntermediateNode) {
      candidate ??= child;
    }

    if (targetChildren.contains(candidate)) {
      logger.warning(
          'Tried adding ${candidate.runtimeType.toString()} again to ${target.runtimeType.toString()}');
      return;
    }

    if (candidate is PBIntermediateNode) {
      if (targetChildren.length > 1) {
        logger.warning(
            'Replacing children of ${target.runtimeType.toString()} with ${candidate.runtimeType.toString()}');
      }

      /// replacing the children of [target] with the single element
      tree.replaceChildrenOf(target, [candidate]);
    } else {
      logger.warning(
          'Tried adding ${child.runtimeType.toString()} to ${target.runtimeType.toString()}');
    }
  }
}

class MultipleChildStrategy extends ChildrenStrategy {
  MultipleChildStrategy(String attributeName, [bool overridable])
      : super(attributeName, overridable);

  @override
  void addChild(PBIntermediateNode target, children,
      ChildrenMod<PBIntermediateNode> addChild, tree) {
    if (children is List<PBIntermediateNode>) {
      addChild(target, children);
    } else if (children is PBIntermediateNode) {
      addChild(target, [children]);
    }
  }
}

class NoChildStrategy extends ChildrenStrategy {
  NoChildStrategy([bool overridable]) : super('N/A', overridable);

  @override
  void addChild(PBIntermediateNode target, children,
      ChildrenMod<PBIntermediateNode> addChild, tree) {
    logger.warning(
        'Tried adding ${children.runtimeType.toString()} to ${target.runtimeType.toString()}');
  }
}

class TempChildrenStrategy extends ChildrenStrategy {
  TempChildrenStrategy(String attributeName, [bool overwridable])
      : super(attributeName, overwridable);

  /// Rezising the [target.frame] basedon on the total [children.frame] area.
  void _resizeFrameBasedOn(var children, PBIntermediateNode target) {
    assert(children != null);
    if (children is List<PBIntermediateNode>) {
      target.frame ??= children.first.frame;
      children.forEach(
          (child) => target.frame = target.frame.boundingBox(child.frame));
    } else if (children is PBIntermediateNode) {
      target.frame = target.frame.boundingBox(children.frame);
    }
  }

  bool _containsSingleGroup(
          PBIntermediateNode group, List<PBIntermediateNode> children) =>
      group is TempGroupLayoutNode && children.length == 1;

  @override
  void addChild(PBIntermediateNode target, children,
      ChildrenMod<PBIntermediateNode> addChild, tree) {
    var targetChildren = tree.childrenOf(target);
    var group = targetChildren.firstWhere(
        (element) => element is TempGroupLayoutNode,
        orElse: () => null);
    children = children is List ? children : [children];

    // TempGroup is the only child inside `target`
    if (_containsSingleGroup(group, children)) {
      // Calculate new frame based on incoming child
      _resizeFrameBasedOn(children, group);
      addChild(group, children);
    }

    /// Have no TempGroupLayoutNode but `target` already has children
    else if (targetChildren.isNotEmpty) {
      var temp = TempGroupLayoutNode(null, null, name: '${target.name}Group');
      addChild(temp, targetChildren);
      addChild(temp, children);

      _resizeFrameBasedOn(targetChildren, temp);
      _resizeFrameBasedOn(children, temp);

      tree.removeEdges(target);
      addChild(target, [temp]);
    }
    // Adding a single child to empty `target`
    else {
      addChild(target, children);
    }
  }
}
