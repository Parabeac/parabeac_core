import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

abstract class AlignStrategy<T extends PBIntermediateNode>{
  void align(PBContext context, T node);
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
  }
}

class NoAlignment extends AlignStrategy{
  @override
  void align(PBContext context, PBIntermediateNode node) {
    
  }
}