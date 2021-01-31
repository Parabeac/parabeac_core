import 'package:parabeac_core/design_logic/design_node.dart';

import 'abstract_design_node_factory.dart';

class PBSharedInstanceDesignNode extends DesignNode
    implements DesignNodeFactory {
  String symbolID;
  List parameters;

  PBSharedInstanceDesignNode(
      {String UUID,
      String name,
      bool isVisible,
      boundaryRectangle,
      String type,
      style,
      prototypeNode})
      : super(UUID, name, isVisible, boundaryRectangle, type, style,
            prototypeNode);

  @override
  String pbdfType = 'symbol_instance';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    // TODO implement
    return null;
  }
}
