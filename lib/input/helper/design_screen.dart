import 'package:parabeac_core/design_logic/abstract_design_node_factory.dart';
import 'package:parabeac_core/design_logic/design_node.dart';

class DesignScreen implements DesignNodeFactory {
  String id;
  String name;
  bool convert;
  String imageURI;
  String type;
  DesignNode designNode;

  // Do we still need this?
  // DesignPage parentPage;

  DesignScreen({
    DesignNode designNode,
    this.id,
    this.name,
  }) {
    this.designNode = designNode;
  }

  Map<String, dynamic> toPBDF() {
    Map<String, dynamic> result = {};
    result['pbdfType'] = pbdfType;
    result['id'] = id;
    result['name'] = name;
    result['convert'] = convert;
    result['imageURI'] = imageURI;
    result['type'] = type;
    result['designNode'] = designNode.toPBDF();
    return result;
  }

  @override
  String pbdfType = 'screen';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) {
    // TODO: implement createDesignNode
    throw UnimplementedError();
  }

  factory DesignScreen.fromPBDF(Map<String, dynamic> json) {
    var screen = DesignScreen(name: json['name'], id: json['id']);
    if (json.containsKey('designNode')) {
      screen.designNode = DesignNode.fromPBDF(json['designNode']);
    }
    return screen;
  }
}
