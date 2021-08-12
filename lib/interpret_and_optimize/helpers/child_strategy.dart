import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:quick_log/quick_log.dart';

abstract class ChildrenStrategy {
  Logger log;
  //TODO: will be used in the migrations to attributes
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
      target.child = child;
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
      children.forEach((child) {
        child.parent = target;
        target.children.add(child);
      });
    } else if (children is PBIntermediateNode) {
      target.child = children;
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
    if (target.child is TempGroupLayoutNode) {
      target.child.addChild(children);
    } else if (target.child != null) {
      var temp = TempGroupLayoutNode(null, null,
          currentContext: target.currentContext, name: children.name);
      temp.addChild(target.child);
      temp.addChild(children);
      temp.parent = target;
      target.child = temp;
    } else if (children is PBIntermediateNode) {
      children.parent = target;
      target.child = children;
    }
  }
}
