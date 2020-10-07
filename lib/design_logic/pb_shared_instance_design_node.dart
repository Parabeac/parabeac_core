import 'package:parabeac_core/design_logic/design_node.dart';

abstract class PBSharedInstanceDesignNode extends DesignNode {
  String symbolID;
  List parameters;

  PBSharedInstanceDesignNode(String UUID, String name, bool isVisible,
      boundaryRectangle, String type, style, prototypeNode)
      : super(UUID, name, isVisible, boundaryRectangle, type, style,
            prototypeNode);
}
