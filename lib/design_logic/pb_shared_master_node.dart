import 'package:parabeac_core/design_logic/design_node.dart';

abstract class PBSharedMasterDesignNode extends DesignNode {
  String symbolID;
  List overriadableProperties;

  PBSharedMasterDesignNode(String UUID, String name, bool isVisible,
      boundaryRectangle, String type, style, prototypeNode)
      : super(UUID, name, isVisible, boundaryRectangle, type, style,
            prototypeNode);
}
