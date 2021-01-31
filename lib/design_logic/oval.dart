import 'package:parabeac_core/design_logic/design_node.dart';

import 'abstract_design_node_factory.dart';

class Oval implements DesignNodeFactory {
  @override
  String pbdfType = 'oval';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    // TODO implement
    return null;
  }
}
