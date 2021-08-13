import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:quick_log/quick_log.dart';

abstract class ChildrenStrategy {
  Logger logger;
  final String attributeName;
  final bool overwridable;
  ChildrenStrategy(this.attributeName, this.overwridable) {
    logger = Logger(runtimeType.toString());
  }
  void addChild(PBIntermediateNode target, dynamic children);
}

class OneChildStrategy extends ChildrenStrategy {
  OneChildStrategy(String attributeName, [bool overridable = false])
      : super(attributeName, overridable);

  @override
  void addChild(PBIntermediateNode target, dynamic child) {
    if (child is PBIntermediateNode) {
      child.parent = target;
      target.children = [child];
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
  void addChild(PBIntermediateNode target, children) {
    if (children is List<PBIntermediateNode>) {
      target.children.addAll(children.map((child) {
        child.parent = target;
        return child;
      }));
    } else if (children is PBIntermediateNode) {
      children.parent = target;
      target.children.add(children);
    }
  }
}

class NoChildStrategy extends ChildrenStrategy {
  NoChildStrategy([bool overridable]) : super('N/A', overridable);

  @override
  void addChild(PBIntermediateNode target, children) {
    if (children != null) {
      logger.warning(
          'Tried adding ${children.runtimeType.toString()} to ${target.runtimeType.toString()}');
    }
  }
}

class TempChildrenStrategy extends ChildrenStrategy {
  TempChildrenStrategy(String attributeName, [bool overwridable])
      : super(attributeName, overwridable);

  @override
  void addChild(PBIntermediateNode target, children) {
    var group = target.children.firstWhere(
        (element) => element is TempGroupLayoutNode,
        orElse: () => null);
    if (group != null && target.children.length == 1) {
      // Calculate new frame based on incoming child
      var newFrame = group.frame.boundingBox(children.frame);
      group.addChild(children);
      group.frame = newFrame;
    } else if (target.children.isNotEmpty) {
      var temp = TempGroupLayoutNode(null, null, name: children.name)
        ..addChild(children)
        ..parent = target;
      // Add target's existing children to temp group layout
      target.children.forEach((child) {
        temp.addChild(child);
        child.parent = temp;
      });
      // Calculate bounding box from all children
      var frame = temp.children.first.frame;
      for (var i = 1; i < temp.children.length; i++) {
        frame = frame.boundingBox(temp.children[i].frame);
      }

      temp.frame = frame;
      target.children = [temp];
    } else if (children is PBIntermediateNode) {
      children.parent = target;
      target.children.add(children);
    }
  }
}
