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
    if (child is PBIntermediateNode) {
      addChild(target, [child]);
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

  @override
  void addChild(PBIntermediateNode target, children,
      ChildrenMod<PBIntermediateNode> addChild, tree) {
    var targetChildren = tree.childrenOf(target);
    var group = targetChildren.firstWhere(
        (element) => element is TempGroupLayoutNode,
        orElse: () => null);
    // TempGroup is the only child inside `target`
    if (group != null && targetChildren.length == 1) {
      // Calculate new frame based on incoming child
      var newFrame;
      if (children is List) {
        newFrame = group.frame.boundingBox(children.first.frame);
      } else {
        newFrame = group.frame.boundingBox(children.frame);
      }
      addChild(group, targetChildren);
      group.frame = newFrame;
    }
    // Have no TempGroupLayoutNode but `target` already has children
    else if (targetChildren.isNotEmpty) {
      var temp = TempGroupLayoutNode(null, null, name: '${target.name}Group');
      addChild(temp, targetChildren);

      var tempChildren = tree.childrenOf(temp);

      // Calculate bounding box from all children
      var frame = tempChildren.first.frame;
      for (var i = 1; i < tempChildren.length; i++) {
        frame = frame.boundingBox(tempChildren[i].frame);
      }

      temp.frame = frame;
      tree.removeEdges(target);
      addChild(target, [temp]);
    }
    // Adding a single child to empty `target`
    else if (children is PBIntermediateNode) {
      addChild(target, [children]);
    } 
    // Adding a list of `children`
    else if (children is List<PBIntermediateNode>) {
      addChild(target, children);
    }
  }
}
