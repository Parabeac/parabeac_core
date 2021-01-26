import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/helper/design_page.dart';

class DesignScreen {
  String id;
  String name;
  bool convert;
  String imageURI;
  String type;
  DesignNode designNode;

  // Do we still need this?
  // DesignPage parentPage;

  DesignScreen(
    this.designNode,
    this.id,
    this.name,
  );

  Map<String, Object> toJson() => designNode.toJson();
}
