import 'package:parabeac_core/input/helper/design_page.dart';
import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:parabeac_core/input/helper/design_screen.dart';

import 'artboard.dart';
import 'boolean_operation.dart';
import 'design_node.dart';
import 'group_node.dart';
import 'image.dart';
import 'oval.dart';
import 'pb_shared_instance_design_node.dart';
import 'pb_shared_master_node.dart';
import 'polygon.dart';
import 'rectangle.dart';
import 'star.dart';
import 'text.dart';
import 'vector.dart';

class AbstractDesignNodeFactory {
  static final String DESIGN_CLASS_KEY = 'pbdfType';

  static final List<DesignNodeFactory> _designNodes = [
    PBArtboard(),
    BooleanOperation(),
    GroupNode(),
    Image(),
    Oval(),
    PBSharedInstanceDesignNode(),
    PBSharedMasterDesignNode(),
    Polygon(),
    Rectangle(),
    Star(),
    Text(),
    Vector(),
    DesignProject(),
    DesignPage(),
    DesignScreen(),
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
