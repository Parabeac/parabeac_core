import 'dart:math';

import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
// import 'dart:math';

/// Represents a typical node that the end-user could see, it usually has properties such as size and color. It only contains a single child, unlike PBLayoutIntermediateNode that contains a set of children.
/// Superclass: PBIntermediateNode
abstract class PBVisualIntermediateNode extends PBIntermediateNode {


  PBVisualIntermediateNode(Point topLeftCorner, Point bottomRightCorner,
      PBContext currentContext, String name,
      {String UUID, PBIntermediateConstraints constraints})
      : super(topLeftCorner, bottomRightCorner, UUID, name,
            currentContext: currentContext, constraints: constraints);


}
