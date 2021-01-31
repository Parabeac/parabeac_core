import 'package:parabeac_core/input/helper/design_page.dart';
import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:parabeac_core/input/helper/design_screen.dart';

import 'artboard.dart';
import 'design_node.dart';

class AbstractDesignNodeFactory {
  static final String DESIGN_CLASS_KEY = 'pbdfType';

  static final List<DesignNodeFactory> _designNodes = [
    PBArtboard(),
    DesignProject(),
    DesignPage(),
    DesignScreen(),
    // TODO: add classes
  ];

  AbstractDesignNodeFactory();

  static DesignNode getDesignNode(Map<String, dynamic> json) {
    var className = json[DESIGN_CLASS_KEY];
    if (className != null) {
      for (var designNode in _designNodes) {
        if (designNode.pbdfType == className) {
          return designNode.createDesignNode(json);
        }
      }
    }
    return null;
  }
}

abstract class DesignNodeFactory {
  String pbdfType;
  DesignNode createDesignNode(Map<String, dynamic> json);
}
