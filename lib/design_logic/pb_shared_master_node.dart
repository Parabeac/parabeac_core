import 'package:parabeac_core/design_logic/design_node.dart';

class PBSharedMasterDesignNode extends DesignNode {
  String symbolID;
  List overriadableProperties;

  PBSharedMasterDesignNode(String UUID, String name, bool isVisible,
      boundaryRectangle, String type, style, prototypeNode)
      : super(UUID, name, isVisible, boundaryRectangle, type, style,
            prototypeNode);

  @override
  String pbdfType = 'symbol_master';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    // TODO implement
    return null;
  }
}
