import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/group_node.dart';
import 'package:parabeac_core/design_logic/rect.dart';

abstract class PBArtboard extends DesignNode implements GroupNode {
  var backgroundColor;
  PBArtboard(this.backgroundColor, UUID, String name, bool isVisible,
      Rect boundaryRectangle, String type, style, prototypeNode)
      : super(UUID, name, isVisible, boundaryRectangle, type, style,
            prototypeNode);
}
