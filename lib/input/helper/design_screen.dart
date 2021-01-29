import 'package:parabeac_core/design_logic/design_node.dart';

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
    DesignNode designNode,
    this.id,
    this.name,
  ) {
    this.designNode = designNode;
  }

  Map<String, dynamic> toPBDF() {
    Map<String, dynamic> result = {};
    result['id'] = id;
    result['name'] = name;
    result['convert'] = convert;
    result['imageURI'] = imageURI;
    result['type'] = type;
    result['designNode'] = designNode.toPBDF();
    return result;
  }
}
