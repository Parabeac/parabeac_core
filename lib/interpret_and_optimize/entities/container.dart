import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import 'injected_container.dart';

class PBContainer extends PBIntermediateNode {
  bool showWidth;
  bool showHeight;
  InjectedPadding padding;

  PBContainer({String UUID, Rectangle3D<num> frame, String name})
      : super(UUID, frame, name);
}
