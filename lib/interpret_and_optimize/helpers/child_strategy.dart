import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:quick_log/quick_log.dart';

abstract class ChildrenStrategy {
  Logger log;
  final String attributeName;
  final bool overwridable;
  ChildrenStrategy(this.attributeName, this.overwridable) {
    log = Logger(runtimeType.toString());
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
      log.warning(
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
      var node = children;
      node.parent = target;
      node.children.forEach(target.addChild);
    }
  }
}

class NoChildStrategy extends ChildrenStrategy {
  NoChildStrategy([bool overridable]) : super('N/A', overridable);

  @override
  void addChild(PBIntermediateNode target, children) {
    if (children != null) {
      log.warning(
          'Tried adding ${children.runtimeType.toString()} to ${target.runtimeType.toString()}');
    }
  }
}

class TempChildrenStrategy extends ChildrenStrategy {
  TempChildrenStrategy(String attributeName, [bool overwridable])
      : super(attributeName, overwridable);

  @override
  void addChild(PBIntermediateNode target, children) {
    var group =
        target.children.firstWhere((element) => element is TempGroupLayoutNode);
    if (group != null && target.children.length == 1) {
      group.addChild(children);
    } else if (target.children.isNotEmpty) {
      var child = target.children.first;
      var temp = TempGroupLayoutNode(null, null, name: children.name)
        ..addChild(child)
        ..addChild(children)
        ..parent = target;
      target.children = [temp];
    } else if (children is PBIntermediateNode) {
      children.parent = target;
      target.addChild(children);
    }
  }
}
