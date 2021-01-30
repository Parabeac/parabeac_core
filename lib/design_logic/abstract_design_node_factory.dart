import 'artboard.dart';
import 'design_node.dart';

class AbstractDesignNodeFactory {
  static final String DESIGN_CLASS_KEY = 'pbdfType';

  static final List<DesignNodeFactory> _designNodes = [
    PBArtboard(),
    // TODO: add classes
  ];

  AbstractDesignNodeFactory();

  static DesignNode getDesignNode(Map<String, dynamic> json) {
    var className = json[DESIGN_CLASS_KEY];
    if (className != null) {
      for (var designNode in _designNodes) {
        if (designNode.type == className) {
          return designNode.createDesignNode(json);
        }
      }
    }
    return null;
  }
}

abstract class DesignNodeFactory {
  String type;
  DesignNode createDesignNode(Map<String, dynamic> json);
}
