import 'package:parabeac_core/design_logic/design_node.dart';

abstract class PBSharedInstanceNodeDesign extends DesignNode {
  String symbolID;
  List parameters;

  PBSharedInstanceNodeDesign(String UUID, String name, bool isVisible,
      boundaryRectangle, String type, style, prototypeNode)
      : super(UUID, name, isVisible, boundaryRectangle, type, style,
            prototypeNode);
}
