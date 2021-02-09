import 'package:parabeac_core/design_logic/design_node.dart';

abstract class DesignElement extends DesignNode {
  DesignElement({
    UUID,
    name,
    isVisible,
    boundaryRectangle,
    type,
    style,
    prototypeNodeUUID,
  }) : super(
          UUID,
          name,
          isVisible,
          boundaryRectangle,
          type,
          style,
          prototypeNodeUUID,
        );
}
