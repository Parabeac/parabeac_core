import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/group_node.dart';
import 'package:parabeac_core/design_logic/rect.dart';

import 'abstract_design_node_factory.dart';

class PBArtboard extends DesignNode implements GroupNode, DesignNodeFactory {
  PBColor backgroundColor;
  PBArtboard(
      {this.backgroundColor,
      UUID,
      String name,
      bool isVisible,
      Rect boundaryRectangle,
      String type,
      style,
      prototypeNode})
      : super(UUID, name, isVisible, boundaryRectangle, type, style,
            prototypeNode);

  @override
  List children;

  @override
  String pbdfType = 'artboard';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    // TODO implement
    return null;
  }
}
