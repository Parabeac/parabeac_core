import 'package:parabeac_core/interpret_and_optimize/entities/alignments/injected_positioned.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:uuid/uuid.dart';

abstract class AlignStrategy<T extends PBIntermediateNode>{
  void align(PBContext context, T node);

  void _setConstraints(PBContext context, T node){
    if(node.constraints.fixedHeight != null){
      context.contextConstraints.fixedHeight = node.constraints.fixedHeight;
    }
    if(node.constraints.fixedWidth != null){
      context.contextConstraints.fixedWidth = node.constraints.fixedWidth;
    }
  }
}

class PaddingAlignment extends AlignStrategy{
  @override
  void align(PBContext context, PBIntermediateNode node) {
    var padding = Padding('', node.child.constraints,
        left: (node.child.topLeftCorner.x - node.topLeftCorner.x).abs(),
        right: (node.bottomRightCorner.x - node.child.bottomRightCorner.x).abs(),
        top: (node.child.topLeftCorner.y - node.topLeftCorner.y).abs(),
        bottom: (node.child.bottomRightCorner.y - node.bottomRightCorner.y).abs(),
        topLeftCorner: node.topLeftCorner,
        bottomRightCorner: node.bottomRightCorner,
        currentContext: node.currentContext);
    padding.addChild(node.child);
    node.child = padding;
    super._setConstraints(context, node);
  }
}

class NoAlignment extends AlignStrategy{
  @override
  void align(PBContext context, PBIntermediateNode node) {
    super._setConstraints(context, node);
  }
}

class PositionedAlignment extends AlignStrategy<PBIntermediateStackLayout> {
  /// Do we need to subtract some sort of offset? Maybe child.topLeftCorner.x - topLeftCorner.x?

  @override
  void align(PBContext context, PBIntermediateStackLayout node) {
    var alignedChildren = <PBIntermediateNode>[];
    node.children.skipWhile((child) {
      /// if they are the same size then there is no need for adjusting.
      if (child.topLeftCorner == node.topLeftCorner &&
          child.bottomRightCorner == node.bottomRightCorner) {
        alignedChildren.add(child);
        return true;
      }
      return false;
    }).forEach((child) {
      alignedChildren.add(InjectedPositioned(Uuid().v4(),
          child.topLeftCorner.clone(), child.bottomRightCorner.clone(),
          constraints: child.constraints,
          currentContext: context,
          valueHolder: PositionedValueHolder(
              top: child.topLeftCorner.y - node.topLeftCorner.y,
              bottom: node.bottomRightCorner.y - child.bottomRightCorner.y,
              left: child.topLeftCorner.x - node.topLeftCorner.x,
              right: node.bottomRightCorner.x - child.bottomRightCorner.x,
              width: child.width,
              height: child.height))
        ..addChild(child));
    });
    node.replaceChildren(alignedChildren);
    super._setConstraints(context, node);
  }
}