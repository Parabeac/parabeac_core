import 'package:parabeac_core/design_logic/design_node.dart';

class DesignScreen {
  String id;
  String name;
  bool convert;
  String imageURI;
  String type;
  var designNode;

  // Do we still need this?
  // DesignPage parentPage;

  DesignScreen(
    DesignNode designNode,
    this.id,
    this.name,
  ) {
    this.designNode = designNode;
  }

  Map<String, Object> toPBDF() => designNode.toPBDF();
}
